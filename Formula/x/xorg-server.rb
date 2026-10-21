class XorgServer < Formula
  desc "X Window System display server"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/xserver/xorg-server-21.1.25.tar.xz"
  sha256 "6ad4e3c7b59a309b32c92e5c15ce1267110f9e13f1ac78da62361a628da1a0eb"
  license all_of: ["MIT", "APSL-2.0"]
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(/href=.*?xorg-server[._-]v?(\d+\.\d+(?:\.(?:\d|[0-8]\d+))+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "c2b6d8dd41f009e5bacac7a9999b367d03bcedb91e9bccd39f7be495d806de12"
    sha256 arm64_tahoe:       "c6738cea442e5fdaae03d0714082e941c06bc421ed63b392987a8f8c5b5010d6"
    sha256 arm64_sequoia:     "2d5e9090c04d1684b10f906a2c384ed746c5f928f0474d85dbc9fa24516cf9b8"
    sha256 arm64_linux:       "551f053e60b0b4aab463f5bcc8ecac5c3188b7f05d49f0b98b8fc60f2108614d"
    sha256 x86_64_linux:      "d202efb7b174727504576cdcd89eba9e1a758047a4778cf3fd0c6c581d03af62"
  end

  depends_on "font-util"   => :build
  depends_on "libxkbfile"  => :build
  depends_on "meson"       => :build
  depends_on "ninja"       => :build
  depends_on "pkgconf"     => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => :build
  depends_on "xtrans"      => :build

  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxcb"
  depends_on "libxdmcp"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxfont2"
  depends_on "mesa"
  depends_on "pixman"
  depends_on "xauth"
  depends_on "xcb-util"
  depends_on "xcb-util-image"
  depends_on "xcb-util-keysyms"
  depends_on "xcb-util-renderutil"
  depends_on "xcb-util-wm"
  depends_on "xkbcomp"
  depends_on "xkeyboard-config"

  on_macos do
    depends_on "libapplewm"

    # Case-insensitive filesystem conflict
    conflicts_with "x-cli", because: "both provide an `x` binary"
  end

  on_linux do
    depends_on "dbus"
    depends_on "libdrm"
    depends_on "libepoxy"
    depends_on "libpciaccess"
    depends_on "libtirpc"
    depends_on "libxcvt"
    depends_on "libxshmfence"
    depends_on "openssl@4"
    depends_on "systemd"

    resource "xvfb-run" do
      url "https://salsa.debian.org/xorg-team/xserver/xorg-server/-/raw/xorg-server-2_21.1.20-1/debian/local/xvfb-run"
      sha256 "97e86a102eee7212bfa3bf87d452b27dd4f16ef6e68658eeae20bca63db2ceee"
    end

    resource "xvfb-run.1" do
      url "https://salsa.debian.org/xorg-team/xserver/xorg-server/-/raw/xorg-server-2_21.1.20-1/debian/local/xvfb-run.1"
      sha256 "7e8e39c98ae006b8ba583b59c8be0419885eaead062c3ae87592854de33e5a00"
    end
  end

  allow_network_access! :test

  def install
    # ChangeLog contains some non relocatable strings
    rm "ChangeLog"
    meson_args = std_meson_args(prefix: HOMEBREW_PREFIX) + %W[
      -Dxephyr=true
      -Dxf86bigfont=true
      -Dxcsecurity=true

      -Dbundle-id-prefix=#{Formula["xinit"].plist_name.chomp ".startx"}
      -Dbuilder_addr=#{tap.remote}
      -Dbuilder_string=#{tap.name}
    ]
    meson_args += if OS.mac?
      # macOS doesn't provide `authdes_cred` so `secure-rpc=false`
      # glamor needs GLX with `libepoxy` on macOS
      %w[
        -Dsecure-rpc=false
        -Dapple-applications-dir=libexec
      ]
    else
      # Linux dependency tree already includes OpenSSL
      %w[-Dsha1=libcrypto]
    end

    # X11.app need startx etc. in the same directory
    destdir = buildpath/"dest"
    system "meson", "setup", *meson_args, "build"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build", "--destdir", destdir
    prefix.install Dir["#{destdir}#{HOMEBREW_PREFIX}/*"]
    # follow https://github.com/XQuartz/XQuartz/blob/main/compile.sh#L955
    bin.install_symlink bin/"Xquartz" => "X" if OS.mac?

    if OS.linux?
      bin.install resource("xvfb-run")
      man1.install resource("xvfb-run.1")
    end
  end

  def caveats
    <<~EOS
      To launch X server, it is recommend to install xinit,
      especially on macOS, otherwise X11.app will not work:
        brew install xinit
      If cask xquartz is installed, this link may be helpful:
        https://www.xquartz.org/FAQs.html#want-another-x11app-server
    EOS
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <xcb/xcb.h>

      int main(void) {
        xcb_connection_t *connection = xcb_connect(NULL, NULL);
        int has_err = xcb_connection_has_error(connection);
        assert(has_err == 0);
        xcb_disconnect(connection);
        return 0;
      }
    C
    system ENV.cc, "./test.c", "-o", "test", "-I#{formula_opt_include("libxcb")}",
                                             "-L#{formula_opt_lib("libxcb")}", "-lxcb"

    display = free_port - 6000
    xvfb_pid = spawn bin/"Xvfb", ":#{display}", "-nolisten", "unix", "-listen", "tcp"
    with_env(DISPLAY: "127.0.0.1:#{display}") do
      sleep 10
      system "./test"
      system bin/"xvfb-run", "./test" if OS.linux?
    ensure
      Process.kill("TERM", xvfb_pid)
      Process.wait(xvfb_pid)
    end
  end
end
