class Xinit < Formula
  desc "Start the X Window System server"
  homepage "https://gitlab.freedesktop.org/xorg/app/xinit"
  url "https://www.x.org/releases/individual/app/xinit-1.4.2.tar.xz"
  sha256 "b7d8dc8d22ef9f15985a10b606ee4f2aad6828befa437359934647e88d331f23"
  license all_of: ["MIT", "APSL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "15d5a518d2a37401674216f24e90c812d27b7ce053f67325be0524152210df44"
    sha256 cellar: :any,                 arm64_sonoma:   "b5dbad520af878ccb170fb1924e58f0bcb0c384377ae7aaca2d64091aa8ff4ee"
    sha256 cellar: :any,                 arm64_ventura:  "0fbd33c0f3e8a01224d5f4c2f1437236957d9f9b80d0199f6bf729fe783320c9"
    sha256 cellar: :any,                 arm64_monterey: "b32fd947d6ab4e3d27cae884ecba3d25d618cc5df48869995db8211857a75cf9"
    sha256                               arm64_big_sur:  "e3fa6b976ee03fddeea911fb37cf872c72b23b8a4b00ed11299925656b983fd5"
    sha256                               sonoma:         "579c01be1581c78fb55db87ed20f5c6b5ed0db7e39ab9f48f39882b2ee1886e6"
    sha256                               ventura:        "3db4e377fbe430f3ea074f0ec1f433b3b7278aa451da736d95a8a1ff72e87047"
    sha256 cellar: :any,                 monterey:       "b206deb4ff3200499ab32a8984c90901277094697eaed812ec0e8d10765e64d6"
    sha256 cellar: :any,                 big_sur:        "1b62cbaab6ec39e95a11057e5ce26209c5b4f5696eaab24c0a59e1b7374a7fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "540015cba432ff1f7e719b37f9c2c3af6d8f40784840eeb8e8774cf8575b82a0"
  end

  depends_on "pkg-config" => :build
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
      url "https://github.com/XQuartz/XQuartz/archive/refs/tags/XQuartz-2.8.2.tar.gz"
      sha256 "050c538cf2ed39f49a366c7424c7b22781c9f7ebe02aa697f12e314913041000"
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

    configure_args = std_configure_args + %W[
      --bindir=#{HOMEBREW_PREFIX}/bin
      --sysconfdir=#{etc}
      --with-bundle-id-prefix=#{plist_name.chomp ".startx"}
      --with-launchagents-dir=#{prefix}
      --with-launchdaemons-dir=#{prefix}
    ]

    system "./configure", *configure_args
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
    exec bin/"xinit", "./test", "--", Formula["xorg-server"].bin/"Xvfb", ":1"
  end
end
