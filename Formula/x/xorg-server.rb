class XorgServer < Formula
  desc "X Window System display server"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/xserver/xorg-server-21.1.24.tar.xz"
  sha256 "1a4eb36ca65cc3b1b936566d677a9786e13c11cd5806e951ac55f3f5ce3984af"
  license all_of: ["MIT", "APSL-2.0"]
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "277d48e1ae129f621928d182dfb59d436bee94ef8c82f8ab18740b117b599ad0"
    sha256 arm64_sequoia: "0d8b6a8652cae487783f961c1a6d0f77f64542ca0d3a268f4f0386005ec538ff"
    sha256 arm64_sonoma:  "7d571a9fe7dbf3520b5059f25e6ccde4ceec3da503ae1c37df27052501fb4c32"
    sha256 sonoma:        "d00d56efb37d75edfee2a1fc44a03d297904d6eaecdfaa4c88cdd659798ffb12"
    sha256 arm64_linux:   "49ebbe4fc3a9117f274e5c1ab0f5e1c0942ab07fa855ac5c3b7086f8865390e3"
    sha256 x86_64_linux:  "7c4871c037d6635b9d798825c58f1745d19d3fc4e29cf1c588bd758f7375c4ef"
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
    depends_on "openssl@3"
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
    xcb = Formula["libxcb"]
    system ENV.cc, "./test.c", "-o", "test", "-I#{xcb.include}", "-L#{xcb.lib}", "-lxcb"

    xvfb_pid = spawn bin/"Xvfb", ":1"
    with_env(DISPLAY: ":1") do
      sleep 10
      sleep 30 if OS.mac? && Hardware::CPU.intel?
      system "./test"
      system bin/"xvfb-run", "./test" if OS.linux?
    ensure
      Process.kill("TERM", xvfb_pid)
    end
  end
end
