class XorgServer < Formula
  desc "X Window System display server"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/xserver/xorg-server-21.1.4.tar.xz"
  sha256 "5cc4be8ee47edb58d4a90e603a59d56b40291ad38371b0bd2471fc3cbee1c587"
  license all_of: ["MIT", "APSL-2.0"]

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
    depends_on "libxcvt"
    depends_on "libxshmfence"
    depends_on "nettle"
    depends_on "systemd"
  end

  def install
    rm "ChangeLog"
    # align with formula `font-util`
    font_path = %w[misc TTF OTF Type1 100dpi 75dpi].map do |p|
      HOMEBREW_PREFIX/"share/fonts/X11"/p
    end
    if OS.mac?
      font_path += %W[
        #{HOMEBREW_PREFIX}/share/system_fonts
        /Library/Fonts
        /System/Library/Fonts
      ]
    end
    meson_args = std_meson_args + %W[
      -Dxephyr=true
      -Dxf86bigfont=true
      -Dxcsecurity=true

      -Dmodule_dir=#{HOMEBREW_PREFIX}/lib/xorg/modules
      -Ddefault_font_path=#{font_path.join ","}
      -Dxkb_dir=#{HOMEBREW_PREFIX}/share/X11/xkb
      -Dxkb_bin_dir=#{Formula["xkbcomp"].opt_bin}
      -Dxkb_output_dir=#{HOMEBREW_PREFIX}/X11/xkb/compiled

      -Dbundle-id-prefix=#{Formula["xinit"].plist_name.chomp ".startx"}
      -Dbuilder_addr=#{tap.remote}
      -Dbuilder_string=#{tap.name}
    ]
    # macOS doesn't provide `authdes_cred` so `secure-rpc=false`
    # glamor needs GLX with `libepoxy` on macOS
    if OS.mac?
      meson_args += %W[
        -Dsecure-rpc=false
        -Dapple-applications-dir=#{libexec}
      ]
      # Set macro `X11BINDIR` to `HOMEBREW_PREFIX/bin` rather than `prefix/bin`
      # so it can find and launch X apps from Homebrew e.g. `xterm`.
      inreplace "hw/xquartz/mach-startup/meson.build", "get_option('prefix')", "'#{HOMEBREW_PREFIX}'"
    end

    system "meson", "build", *meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
    # follow https://github.com/XQuartz/XQuartz/blob/main/compile.sh#L955
    bin.install_symlink bin/"Xquartz" => "X" if OS.mac?
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
  end
end
