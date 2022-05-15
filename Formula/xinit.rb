class Xinit < Formula
  desc "Start the X Window System server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xinit"
  url "https://www.x.org/releases/individual/app/xinit-1.4.1.tar.bz2"
  sha256 "de9b8f617b68a70f6caf87da01fcf0ebd2b75690cdcba9c921d0ef54fa54abb9"
  license all_of: ["MIT", "APSL-2.0"]

  depends_on "pkg-config" => :build
  depends_on "tradcpp"    => :build

  depends_on "libx11"
  depends_on "lndir"
  depends_on "mkfontscale"
  depends_on "xauth"
  depends_on "xmodmap"
  depends_on "xorg-server"
  depends_on "xrdb"
  depends_on "xterm"

  on_macos do
    depends_on "quartz-wm"

    def caveats
      privileged_plist = "#{plist_name.chomp ".startx"}.privileged_startx.plist"
      <<~EOS
        To use Homebrew's X11 as the default server, you need to run:
          `brew services start xinit`
        Note that doing this may cause the `Xquartz` to fail to launch.
        For more info, see https://www.xquartz.org/FAQs.html
        To enable the service `privileged_startx`, you need to run
          `sudo cp #{opt_prefix}/#{privileged_plist} /Library/LaunchDaemons/`
        and take root:admin ownership of some xinit paths:
          #{opt_libexec}
          #{opt_libexec}/privileged_startx
          #{opt_prefix}
          #{opt_bin}
          #{HOMEBREW_PREFIX}/var/homebrew/linked/xinit
        Then bootstrap the service:
          `sudo launchctl bootstrap system /Library/LaunchDaemons/#{privileged_plist}`
        This will require manual removal of these paths using `sudo rm` on
        brew upgrade/reinstall/uninstall.
      EOS
    end
  end

  on_linux do
    depends_on "twm"
    depends_on "util-linux"
  end

  resource "font_cache" do
    url "https://raw.githubusercontent.com/XQuartz/XQuartz/XQuartz-2.8.1/base/opt/X11/bin/font_cache"
    sha256 "8f27cf55e5053686350fce6ea1078e314bd5b2d752e9da1b9051541e643e79d6"
  end

  resource "98-user.sh" do
    url "https://raw.githubusercontent.com/XQuartz/XQuartz/XQuartz-2.8.1/base/opt/X11/etc/X11/xinit/xinitrc.d/98-user.sh"
    sha256 "b417aea949931b7c03133535c3b5146b9403b8c3482a1c1d0a5dc01c07876c84"
  end

  def install
    configure_args = std_configure_args + %W[
      --with-bundle-id-prefix=homebrew.mxcl
      --with-launchagents-dir=#{prefix}
      --with-launchdaemons-dir=#{prefix}
      --with-xserver=#{Formula["xorg-server"].bin}/X
    ]

    system "./configure", *configure_args
    system "make", "RAWCPP=tradcpp"
    system "make", "install"

    if OS.mac?
      # Set `bindir` to `HOMEBREW_PREFIX/bin` so `X11.app` can find `xauth`
      # and other utilities, otherwise `X11.app` will restart infinitely when
      # launching from Finder.
      inreplace bin/"startx", /(?<=^bindir=).*/, HOMEBREW_PREFIX/"bin"

      # install scripts
      bin.install resource("font_cache")
      inreplace bin/"font_cache" do |s|
        # set `X11DIR`
        s.gsub! "/opt/X11", HOMEBREW_PREFIX
        # provided by formula `procmail`
        s.gsub! "/usr/bin/lockfile", HOMEBREW_PREFIX/"bin/lockfile"
        # set `X11FONTDIR`, align with formula `font-util`
        s.gsub! "/share/fonts", "/share/fonts/X11"
      end

      (prefix/"etc/X11/xinit/xinitrc.d").install resource("98-user.sh")

      # align with formula `font-util`
      font_paths = %w[misc TTF OTF Type1 75dpi 100dpi system_fonts].map do |f|
        HOMEBREW_PREFIX/"share/fonts/X11"/f
      end
      font_paths += %w[$HOME/.fonts $HOME/Library/Fonts /Library/Fonts]
      font_paths.map! do |p|
        %Q([ -e #{p}/fonts.dir ] && fontpath="$fontpath,#{p}#{",#{p}/:unscaled" if /\d+dpi/.match? p}")
      end
      (prefix/"etc/X11/xinit/xinitrc.d/10-fontdir.sh").write <<~SH
        #!/bin/sh
        if [ -x #{HOMEBREW_PREFIX}/bin/xset ] ; then
          fontpath="built-ins"
          #{font_paths.join "\n  "}

          #{HOMEBREW_PREFIX}/bin/xset fp= "$fontpath"
          unset fontpath
        fi
      SH

      (prefix/"etc/X11/xinit/xinitrc.d/99-quartz-wm.sh").write <<~SH
        #!/bin/sh
        [ -n "${USERWM}" -a -x "${USERWM}" ] && exec "${USERWM}"
        [ -x #{HOMEBREW_PREFIX}/bin/quartz-wm ] && exec #{HOMEBREW_PREFIX}/bin/quartz-wm
      SH

      %w[98-user 10-fontdir 99-quartz-wm].each do |x|
        chmod "+x", prefix/"etc/X11/xinit/xinitrc.d/#{x}.sh"
      end
    end
  end

  def post_install
    if OS.mac?
      # generate fonts dir
      mkdir_p share/"X11/system_fonts"
      system Formula["lndir"].bin/"lndir", "/System/Library/Fonts", share/"X11/system_fonts"
      system Formula["mkfontscale"].bin/"mkfontdir", share/"X11/system_fonts"
    end
  end

  def plist_name
    "homebrew.mxcl.startx"
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
    ENV["DISPLAY"] = ":1"
    fork do
      exec bin/"xinit", "--", Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    sleep 10
    system "./test"
  end
end
