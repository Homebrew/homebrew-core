class XorgServer < Formula
  desc "X Window System display server"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/xserver/xorg-server-21.1.23.tar.xz"
  sha256 "e39832e5617dadaf072fdf9f0e19e5d2e1c2a13607ac280bac1aba9f8fe14634"
  license all_of: ["MIT", "APSL-2.0"]
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "5eb5288787f02f75e41d4fe9491f36213dea58c6d1ca0cc2f53418fc35580db8"
    sha256 arm64_sequoia: "6ece7c1e1979624191d5d0906a6e5b6a40966432a1633e3f5da8a751e1d73a83"
    sha256 arm64_sonoma:  "65c196817c2dd27b1c52b556a2cdc2f866212aff7311f230a29c0604351798f1"
    sha256 sonoma:        "d1134ab8bfa1fb1711a471b3412ebce9cb11f475056b6d0dd492120232ead4ce"
    sha256 arm64_linux:   "bbb6c1df36e85af051256da93d91c36e89ac2165a7a32df4d301a65fe3f264f1"
    sha256 x86_64_linux:  "e9c7c7537e53ab4279f1b9febacd5c3d17ca0906877e78bcf87e6cd0b61e712b"
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
    depends_on "nettle"
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
    meson_args = std_meson_args.map { |s| s.sub prefix, HOMEBREW_PREFIX } + %W[
      -Dxephyr=true
      -Dxf86bigfont=true
      -Dxcsecurity=true

      -Dbundle-id-prefix=#{Formula["xinit"].plist_name.chomp ".startx"}
      -Dbuilder_addr=#{tap.remote}
      -Dbuilder_string=#{tap.name}
    ]
    # macOS doesn't provide `authdes_cred` so `secure-rpc=false`
    # glamor needs GLX with `libepoxy` on macOS
    if OS.mac?
      meson_args += %w[
        -Dsecure-rpc=false
        -Dapple-applications-dir=libexec
      ]
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
