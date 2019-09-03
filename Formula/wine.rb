# NOTE: When updating Wine, please make sure to match Wine-Gecko and Wine-Mono
# versions:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
# with `GECKO_VERSION` and `MONO_VERSION`, as in:
#    https://source.winehq.org/git/wine.git/blob/refs/tags/wine-4.0:/dlls/appwiz.cpl/addons.c
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org/"
  url "https://dl.winehq.org/wine/source/4.0/wine-4.0.2.tar.xz"
  mirror "https://downloads.sourceforge.net/project/wine/Source/wine-4.0.2.tar.xz"
  sha256 "994050692f8417ee206daafa5fc0ff810cc9392ffda1786ac0f0fb0cf74dbd74"
  head "https://source.winehq.org/git/wine.git"

  bottle do
    sha256 "8dfb2b70d3587b88a00b3bf3cce39c970055fc3dff0e446eeeddc4e7c06def82" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "makedepend" => :build

  # High Sierra doesn't support 32-bit builds, and thus wine fails to compile.
  # This will only be safe to remove when upstream support 64-bit builds.
  depends_on :maximum_macos => [:sierra, :build]

  depends_on "pkg-config" => :build
  depends_on :macos => :el_capitan

  resource "mono" do
    url "https://dl.winehq.org/wine/wine-mono/4.7.5/wine-mono-4.7.5.msi"
    sha256 "154d68d476cdedef56f159d837fbb5eef9358a9f85de89f86c189ec4da004b3f"
  end

  resource "gecko-x86" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi"
    sha256 "3b8a361f5d63952d21caafd74e849a774994822fb96c5922b01d554f1677643a"
  end

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi"
    sha256 "c565ea25e50ea953937d4ab01299e4306da4a556946327d253ea9b28357e4a7d"
  end

  resource "openssl" do
    url "https://www.openssl.org/source/openssl-1.0.2s.tar.gz"
    mirror "https://dl.bintray.com/homebrew/mirror/openssl-1.0.2s.tar.gz"
    sha256 "cabd5c9492825ce5bd23f3c3aeed6a97f8142f606d893df216411f07d1abab96"
  end

  resource "libtool" do
    url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
    mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
    sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"
  end

  resource "jpeg" do
    url "https://www.ijg.org/files/jpegsrc.v9c.tar.gz"
    mirror "https://fossies.org/linux/misc/jpegsrc.v9c.tar.gz"
    sha256 "650250979303a649e21f87b5ccd02672af1ea6954b911342ea491f351ceb7122"
  end

  resource "libtiff" do
    url "https://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz"
    mirror "https://fossies.org/linux/misc/tiff-4.0.10.tar.gz"
    sha256 "2c52d11ccaf767457db0c46795d9c7d1a8d8f76f68b0b800a3dfe45786b996e4"
  end

  resource "little-cms2" do
    url "https://downloads.sourceforge.net/project/lcms/lcms/2.9/lcms2-2.9.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/l/lcms2/lcms2_2.9.orig.tar.gz"
    sha256 "48c6fdf98396fa245ed86e622028caf49b96fa22f3e5734f853f806fbc8e7d20"
  end

  resource "libpng" do
    url "https://downloads.sourceforge.net/libpng/libpng-1.6.37.tar.xz"
    mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.37/libpng-1.6.37.tar.xz"
    sha256 "505e70834d35383537b6491e7ae8641f1a4bed1876dbfe361201fc80868d88ca"
  end

  resource "freetype" do
    url "https://downloads.sourceforge.net/project/freetype/freetype2/2.10.1/freetype-2.10.1.tar.xz"
    mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.1.tar.xz"
    sha256 "16dbfa488a21fe827dc27eaf708f42f7aa3bb997d745d31a19781628c36ba26f"
  end

  resource "libusb" do
    url "https://github.com/libusb/libusb/releases/download/v1.0.22/libusb-1.0.22.tar.bz2"
    mirror "https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.22/libusb-1.0.22.tar.bz2"
    sha256 "75aeb9d59a4fdb800d329a545c2e6799f732362193b465ea198f2aa275518157"
  end

  resource "webp" do
    url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.3.tar.gz"
    sha256 "e20a07865c8697bba00aebccc6f54912d6bc333bb4d604e6b07491c1a226b34f"
  end

  resource "fontconfig" do
    url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2"
    mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/fontconfig/fontconfig-2.13.1.tar.bz2"
    sha256 "f655dd2a986d7aa97e052261b36aa67b0a64989496361eca8d604e6414006741"
  end

  resource "gd" do
    url "https://github.com/libgd/libgd/releases/download/gd-2.2.5/libgd-2.2.5.tar.xz"
    mirror "https://src.fedoraproject.org/repo/pkgs/gd/libgd-2.2.5.tar.xz/sha512/946675b0a9dbecdee3dda927d496a35d6b5b071d3252a82cd649db0d959a82fcc65ce067ec34d07eed0e0497cd92cc0d93803609a4854f42d284e950764044d0/libgd-2.2.5.tar.xz"
    sha256 "8c302ccbf467faec732f0741a859eef4ecae22fea2d2ab87467be940842bde51"
  end

  resource "libgphoto2" do
    url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.23/libgphoto2-2.5.23.tar.bz2"
    sha256 "d8af23364aa40fd8607f7e073df74e7ace05582f4ba13f1724d12d3c97e8852d"
  end

  resource "net-snmp" do
    url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.8/net-snmp-5.8.tar.gz"
    sha256 "b2fc3500840ebe532734c4786b0da4ef0a5f67e51ef4c86b3345d697e4976adf"
  end

  resource "sane-backends" do
    url "https://gitlab.com/sane-project/backends/uploads/9e718daff347826f4cfe21126c8d5091/sane-backends-1.0.28.tar.gz"
    sha256 "31260f3f72d82ac1661c62c5a4468410b89fb2b4a811dabbfcc0350c1346de03"
  end

  resource "mpg123" do
    url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.12/mpg123-1.25.12.tar.bz2"
    mirror "https://www.mpg123.de/download/mpg123-1.25.12.tar.bz2"
    sha256 "1ffec7c9683dfb86ea9040d6a53d6ea819ecdda215df347f79def08f1fe731d1"
  end

  def openssl_arch_args
    {
      :x86_64 => %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128],
      :i386   => %w[darwin-i386-cc],
    }
  end

  # Store and restore some of our environment
  def save_env
    saved_cflags = ENV["CFLAGS"]
    saved_ldflags = ENV["LDFLAGS"]
    saved_homebrew_archflags = ENV["HOMEBREW_ARCHFLAGS"]
    saved_homebrew_cccfg = ENV["HOMEBREW_CCCFG"]
    saved_makeflags = ENV["MAKEFLAGS"]
    saved_homebrew_optflags = ENV["HOMEBREW_OPTFLAGS"]
    begin
      yield
    ensure
      ENV["CFLAGS"] = saved_cflags
      ENV["LDFLAGS"] = saved_ldflags
      ENV["HOMEBREW_ARCHFLAGS"] = saved_homebrew_archflags
      ENV["HOMEBREW_CCCFG"] = saved_homebrew_cccfg
      ENV["MAKEFLAGS"] = saved_makeflags
      ENV["HOMEBREW_OPTFLAGS"] = saved_homebrew_optflags
    end
  end

  def install
    # 32-bit support has been removed by Apple.
    if DevelopmentTools.clang_build_version >= 1000
      odie <<~EOS
        Wine cannot currently be installed from source on
        macOS #{MacOS.version}.
        You may wish to try:
          brew install wine --force-bottle
      EOS
    end

    ENV.prepend_create_path "PATH", "#{libexec}/bin"
    ENV.prepend_create_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"

    resource("openssl").stage do
      save_env do
        ENV.deparallelize
        ENV.permit_arch_flags

        # OpenSSL will prefer the PERL environment variable if set over $PATH
        # which can cause some odd edge cases & isn't intended. Unset for safety,
        # along with perl modules in PERL5LIB.
        ENV.delete("PERL")
        ENV.delete("PERL5LIB")

        archs = Hardware::CPU.universal_archs

        dirs = []
        archs.each do |arch|
          dir = "build-#{arch}"
          dirs << dir
          mkdir_p "#{dir}/engines"
          system "make", "clean"
          system "perl", "./Configure", "--prefix=#{libexec}",
                                        "no-ssl2",
                                        "no-ssl3",
                                        "no-zlib",
                                        "shared",
                                        "enable-cms",
                                        *openssl_arch_args[arch]
          system "make", "depend"
          system "make"
          cp "include/openssl/opensslconf.h", dir
          cp Dir["*.?.?.?.dylib", "*.a", "apps/openssl"], dir
          cp Dir["engines/**/*.dylib"], "#{dir}/engines"
        end

        system "make", "install"

        %w[libcrypto libssl].each do |libname|
          rm_f libexec/"lib/#{libname}.1.0.0.dylib"
          MachO::Tools.merge_machos("#{libexec}/lib/#{libname}.1.0.0.dylib",
                                    "#{dirs.first}/#{libname}.1.0.0.dylib",
                                    "#{dirs.last}/#{libname}.1.0.0.dylib")
          rm_f libexec/"lib/#{libname}.a"
        end

        Dir.glob("#{dirs.first}/engines/*.dylib") do |engine|
          libname = File.basename(engine)
          rm_f libexec/"lib/engines/#{libname}"
          MachO::Tools.merge_machos("#{libexec}/lib/engines/#{libname}",
                                    "#{dirs.first}/engines/#{libname}",
                                    "#{dirs.last}/engines/#{libname}")
        end

        MachO::Tools.merge_machos("#{libexec}/bin/openssl",
                                  "#{dirs.first}/openssl",
                                  "#{dirs.last}/openssl")

        confs = archs.map do |arch|
          <<~EOS
            #ifdef __#{arch}__
            #{(Pathname.pwd/"build-#{arch}/opensslconf.h").read}
            #endif
          EOS
        end
        (libexec/"include/openssl/opensslconf.h").atomic_write confs.join("\n")
      end
    end

    depflags = ["CPPFLAGS=-I#{libexec}/include", "LDFLAGS=-L#{libexec}/lib"]

    # All other resources use ENV.universal_binary
    save_env do
      ENV.universal_binary

      resource("libtool").stage do
        ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--program-prefix=g",
                              "--enable-ltdl-install"
        system "make", "install"
      end

      resource("jpeg").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static"
        system "make", "install"
      end

      resource("libtiff").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--disable-lzma",
                              "--without-x",
                              "--with-jpeg-lib-dir=#{libexec}/lib",
                              "--with-jpeg-include-dir=#{libexec}/include"
        system "make", "install"
      end

      resource("little-cms2").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--with-jpeg=#{libexec}",
                              "--with-tiff=#{libexec}"
        system "make", "install"
      end

      resource("libpng").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static"
        system "make", "install"
      end

      resource("freetype").stage do
        system "./configure", "--prefix=#{libexec}",
                              "--disable-static",
                              "--without-harfbuzz",
                              *depflags
        system "make", "install"
      end

      resource("libusb").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static"
        system "make", "install"
      end

      resource("webp").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--disable-gl",
                              "--enable-libwebpmux",
                              "--enable-libwebpdemux",
                              "--enable-libwebpdecoder",
                              *depflags
        system "make", "install"
      end

      resource("fontconfig").stage do
        font_dirs = %w[/System/Library/Fonts /Library/Fonts ~/Library/Fonts]
        if MacOS.version >= :sierra
          font_dirs << Dir["/System/Library/Assets/com_apple_MobileAsset_Font*"].max
        end

        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--with-add-fonts=#{font_dirs.join(",")}",
                              "--localstatedir=#{var}/vendored_wine_fontconfig",
                              "--sysconfdir=#{prefix}",
                              *depflags
        system "make", "install", "RUN_FC_CACHE_TEST=false"
      end

      resource("gd").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--without-x",
                              "--without-xpm",
                              "--with-png=#{libexec}",
                              "--with-fontconfig=#{libexec}",
                              "--with-freetype=#{libexec}",
                              "--with-jpeg=#{libexec}",
                              "--with-tiff=#{libexec}",
                              "--with-webp=#{libexec}"
        system "make", "install"
      end

      resource("libgphoto2").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              *depflags
        system "make", "install"
      end

      resource("net-snmp").stage do
        # https://sourceforge.net/p/net-snmp/bugs/2504/
        ln_s "darwin13.h", "include/net-snmp/system/darwin18.h"

        system "./configure", "--disable-debugging",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--enable-ipv6",
                              "--with-defaults",
                              "--with-persistent-directory=#{var}/db/net-snmp_vendored_wine",
                              "--with-logfile=#{var}/log/snmpd_vendored_wine.log",
                              "--with-mib-modules=host\ ucd-snmp/diskio",
                              "--without-rpm",
                              "--without-kmem-usage",
                              "--disable-embedded-perl",
                              "--without-perl-modules",
                              "--with-openssl=#{libexec}",
                              *depflags
        system "make"
        system "make", "install"
      end

      resource("sane-backends").stage do
        save_env do
          # malloc lives in malloc/malloc.h instead of just malloc.h on macOS.
          # Merge request opened upstream: https://gitlab.com/sane-project/backends/merge_requests/90
          inreplace "backend/ricoh2_buffer.c", "#include <malloc.h>", "#include <malloc/malloc.h>"

          system "./configure", "--disable-dependency-tracking",
                                "--prefix=#{libexec}",
                                "--localstatedir=#{var}",
                                "--without-gphoto2",
                                "--enable-local-backends",
                                "--with-usb=yes",
                                *depflags
          system "make", "install"
        end
      end

      resource("mpg123").stage do
        system "./configure", "--disable-debug",
                              "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--with-default-audio=coreaudio",
                              "--with-module-suffix=.so",
                              "--with-cpu=generic"
        system "make", "install"
      end
    end

    # Help wine find our libraries at runtime
    %w[freetype jpeg png sane tiff].each do |dep|
      ENV["ac_cv_lib_soname_#{dep}"] = (libexec/"lib/lib#{dep}.dylib").realpath
    end

    mkdir "wine-64-build" do
      system "../configure", "--prefix=#{prefix}",
                             "--enable-win64",
                             "--without-x",
                             *depflags
      system "make", "install"
    end

    mkdir "wine-32-build" do
      ENV.m32
      system "../configure", "--prefix=#{prefix}",
                             "--with-wine64=../wine-64-build",
                             "--without-x",
                             *depflags
      system "make", "install"
    end
    (pkgshare/"gecko").install resource("gecko-x86")
    (pkgshare/"gecko").install resource("gecko-x86_64")
    (pkgshare/"mono").install resource("mono")
  end

  def post_install
    # For fontconfig
    ohai "Regenerating font cache, this may take a while"
    system "#{libexec}/bin/fc-cache", "-frv"

    # For net-snmp
    (var/"db/net-snmp_vendored_wine").mkpath
    (var/"log").mkpath
  end

  def caveats; <<~EOS
    You may also want winetricks:
      brew install winetricks
  EOS
  end

  test do
    hostname = shell_output("hostname -s").chomp
    assert_match shell_output("#{bin}/wine hostname.exe 2>/dev/null").chomp, hostname
    assert_match shell_output("#{bin}/wine64 hostname.exe 2>/dev/null").chomp, hostname
  end
end
