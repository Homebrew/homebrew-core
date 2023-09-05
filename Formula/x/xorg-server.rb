class XorgServer < Formula
  desc "X Window System display server"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/xserver/xorg-server-21.1.8.tar.xz"
  sha256 "38aadb735650c8024ee25211c190bf8aad844c5f59632761ab1ef4c4d5aeb152"
  license all_of: ["MIT", "APSL-2.0"]

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "6bb00eac2b812c4b5976e3e01560fa7146e68bf259a6286a428b906b6c6fb205"
    sha256 arm64_monterey: "b4c11cd4d503fcb2201d2c8d1633917357b5a8c5146a0fae47d9904039707df3"
    sha256 arm64_big_sur:  "0eb0e18b02dad58e8f7f07f1165051127cbf9d8bdb043bcdf2e161a8d8348368"
    sha256 ventura:        "b0d9e8ca4de101b4eb6b350994181168a9aa7234d9fc0d8ff8b968a06fec01b6"
    sha256 monterey:       "ca801c81f81f4ba98a565d18cc532a0e49f4b921bb88105e4feaf3c96d5f0527"
    sha256 big_sur:        "aeda4c28fc95f6879ecf0a0e7e355edca5a502342c98b0a2a9b3ce1635a1c700"
    sha256 x86_64_linux:   "5e7848438cd22f634e689249799db39f66b949a48f8dd1f1173e72791e404374"
  end

  depends_on "font-util"   => :build
  depends_on "libxkbfile"  => :build
  depends_on "meson"       => :build
  depends_on "ninja"       => :build
  depends_on "pkg-config"  => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"   => :build
  depends_on "xtrans"      => :build

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
  depends_on "xkeyboardconfig"

  on_macos do
    depends_on "libapplewm"
  end

  on_linux do
    depends_on "dbus"
    depends_on "libdrm"
    depends_on "libepoxy"
    depends_on "libtirpc"
    depends_on "libxcvt"
    depends_on "libxshmfence"
    depends_on "nettle"
    depends_on "systemd"

    resource "xvfb-run" do
      url "https://salsa.debian.org/xorg-team/xserver/xorg-server/-/raw/xorg-server-2_21.1.4-1/debian/local/xvfb-run"
      sha256 "fd05e0f8e6207c3984b980a0f037381c9c4a6f22a6dd94fdcfa995318db2a0a4"
    end

    resource "xvfb-run.1" do
      url "https://salsa.debian.org/xorg-team/xserver/xorg-server/-/raw/xorg-server-2_21.1.4-1/debian/local/xvfb-run.1"
      sha256 "08f14f55e14e52e5d98713c4d8f25ae68d67e2ee188dc0247770c6ada6e27c05"
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
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <xcb/xcb.h>

      int main(void) {
        xcb_connection_t *connection = xcb_connect(NULL, NULL);
        int has_err = xcb_connection_has_error(connection);
        assert(has_err == 0);
        xcb_disconnect(connection);
        return 0;
      }
    EOS
    xcb = Formula["libxcb"]
    system ENV.cc, "./test.c", "-o", "test", "-I#{xcb.include}", "-L#{xcb.lib}", "-lxcb"

    fork do
      exec bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    system "./test"

    system bin/"xvfb-run", "./test" if OS.linux?
  end
end
