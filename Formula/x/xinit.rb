class Xinit < Formula
  desc "Start the X Window System server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xinit"
  url "https://www.x.org/releases/individual/app/xinit-1.4.4.tar.xz"
  sha256 "40a47c7a164c7f981ce3787b4b37f7e411fb43231dcde543d70094075dacfef9"
  license all_of: ["MIT", "APSL-2.0"]

  bottle do
    sha256 arm64_tahoe:   "dd3c7693b0185d79555d1f91e559612ad865688fe779f1c4986f86493058ba6b"
    sha256 arm64_sequoia: "f032d2ee9b34ba1ee42d99701266d51e3dcbdcb30d66883ec8f05033894356bb"
    sha256 arm64_sonoma:  "12231945f0af6967b64ea1e6f992caedcc760a7ed13d142590dab52ae7fc3e96"
    sha256 arm64_ventura: "6f5350a1fceed943594b743212e2ae40e37559e1daa82c31e617311a706ee25a"
    sha256 sonoma:        "14ad40b8e7143eb60fd252ecadaa4012428a33d9572920fc7e4968ac52904d38"
    sha256 ventura:       "caf7be003b70bc8a6a0a2c0fd64df3b6f1479ecb437ecbb00b4675660bf15319"
    sha256 arm64_linux:   "5afccb26823574faa9cc8e322ffa73ba0f5466862dd88ca5a8a4c828ab0d95cc"
    sha256 x86_64_linux:  "8b8186133c32e00a1411809fa7b2569bffacaa9fd2ddbd575605abd3555c6316"
  end

  depends_on "pkgconf" => :build
  depends_on "tradcpp" => :build
  depends_on "xorg-server" => :test

  depends_on "libx11"
  depends_on "xauth"
  depends_on "xmodmap"
  depends_on "xrdb"
  depends_on "xterm"

  on_macos do
    depends_on "lndir" => :build
    depends_on "mkfontscale" => :build

    depends_on "quartz-wm"

    resource "xquartz" do
      url "https://github.com/XQuartz/XQuartz/archive/refs/tags/XQuartz-2.8.5.tar.gz"
      sha256 "5c8c4f48d5e30fdabfba3543174ea67e53f334650b4cfd637714e559eec102d4"
    end
  end

  on_linux do
    depends_on "twm"
    depends_on "util-linux"
  end

  def install_xquartz_resource
    resource("xquartz").stage do
      prefix.install Dir["base/opt/X11/*"]
      (share/"fonts/X11").install share/"fonts/TTF"

      (prefix.glob "**/*").each do |f|
        inreplace f, "/opt/X11", HOMEBREW_PREFIX, audit_result: false if f.file?
      end

      inreplace bin/"font_cache" do |s|
        # provided by formula `procmail`
        s.gsub! %r{/usr/bin(?=/lockfile)}, HOMEBREW_PREFIX
        # set `X11FONTDIR`, align with formula `font-util`
        s.gsub! "share/fonts", "share/fonts/X11"
      end

      # align with formula `font-util`
      font_paths = %w[misc TTF OTF Type1 75dpi 100dpi].map do |f|
        p = HOMEBREW_PREFIX/"share/fonts/X11"/f
        %Q(    [ -e #{p}/fonts.dir ] && fontpath="$fontpath,#{p}#{",#{p}/:unscaled" if /\d+dpi/.match? p}"\n)
      end
      lines = File.readlines prefix/"etc/X11/xinit/xinitrc.d/10-fontdir.sh"
      lines[1] = %Q(    fontpath="built-ins"\n) + font_paths.join
      File.write(prefix/"etc/X11/xinit/xinitrc.d/10-fontdir.sh", lines.join)

      # /System/Library/Fonts is protected by SIP
      mkdir_p share/"system_fonts"
      system Formula["lndir"].bin/"lndir", "/System/Library/Fonts", share/"system_fonts"
      system Formula["mkfontscale"].bin/"mkfontdir", share/"system_fonts"
    end
  end

  def install
    install_xquartz_resource if OS.mac?

    configure_args = %W[
      --bindir=#{HOMEBREW_PREFIX}/bin
      --sysconfdir=#{etc}
      --with-bundle-id-prefix=#{plist_name.chomp ".startx"}
      --with-launchagents-dir=#{prefix}
      --with-launchdaemons-dir=#{prefix}
    ]

    system "./configure", *configure_args, *std_configure_args
    system "make", "RAWCPP=tradcpp"
    system "make", "XINITDIR=#{prefix}/etc/X11/xinit",
                   "sysconfdir=#{prefix}/etc",
                   "bindir=#{bin}", "install"
  end

  def caveats
    <<~EOS
      To start privileged xinit now and restart at login:
        sudo brew services start xinit --file=#{opt_prefix}/#{plist_name.chomp "startx"}privileged_startx.plist
    EOS
  end

  service do
    name macos: "homebrew.mxcl.startx"
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
    exec bin/"xinit", "./test", "--", Formula["xorg-server"].bin/"Xvfb", ":1"
  end
end
