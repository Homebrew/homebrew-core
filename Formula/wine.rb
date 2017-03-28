# NOTE: When updating Wine, please check Wine-Gecko and Wine-Mono for updates
# too:
#  - https://wiki.winehq.org/Gecko
#  - https://wiki.winehq.org/Mono
class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org/"
  head "https://source.winehq.org/git/wine.git"

  stable do
    url "https://dl.winehq.org/wine/source/2.0/wine-2.0.tar.bz2"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-2.0.tar.bz2"
    sha256 "9756f5a2129b6a83ba701e546173cbff86caa671b0af73eb8f72c03b20c066c6"

    # Patch to fix texture compression issues. Still relevant on 2.0.
    # https://bugs.winehq.org/show_bug.cgi?id=14939
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=52384"
      sha256 "30766403f5064a115f61de8cacba1defddffe2dd898b59557956400470adc699"
    end

    # Patch to fix screen-flickering issues. Still relevant on 2.0.
    # https://bugs.winehq.org/show_bug.cgi?id=34166
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=55968"
      sha256 "1b5086798ce6dc959b3cbb8f343ee236ae06c7910e4bbae7d9fde3f162f03a79"
    end
  end

  bottle do
    rebuild 1
    sha256 "a88a5a5a77040bdc38d584fae1a23566b11d1b76e0b740dc76ffdc95a3251e83" => :sierra
    sha256 "41f4842e57f7ad9503f49b5cd7150ebd8ba2ed705be3ef0f19e435e2c3ec204a" => :el_capitan
    sha256 "76b2a1a0266b236cfcc5b36f4c323ee0f76d30908701f1f449472831c83fee5a" => :yosemite
  end

  devel do
    url "https://dl.winehq.org/wine/source/2.x/wine-2.4.tar.xz"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-2.4.tar.xz"
    sha256 "87b5df07e4781fecce2f92415a4717208ea253a20a0df8b36b9f90b69b72748e"

    # Patch to fix screen-flickering issues. Still relevant on 2.3.
    # https://bugs.winehq.org/show_bug.cgi?id=34166
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=57353"
      sha256 "55436526e786c3cac35c7b522f01ca5cc5b826bd0d2bd9e98f53e6a5043a151e"
    end
  end

  if MacOS.version >= :el_capitan
    option "without-win64", "Build without 64-bit support"
    depends_on :xcode => ["8.0", :build] if build.with? "win64"
  end

  # Wine will build both the Mac and the X11 driver by default, and you can switch
  # between them. But if you really want to build without X11, you can.
  depends_on :x11 => :recommended
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "makedepend" => :build

  resource "gecko-x86" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi", :using => :nounzip
    sha256 "3b8a361f5d63952d21caafd74e849a774994822fb96c5922b01d554f1677643a"
  end

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi", :using => :nounzip
    sha256 "c565ea25e50ea953937d4ab01299e4306da4a556946327d253ea9b28357e4a7d"
  end

  resource "mono" do
    url "https://dl.winehq.org/wine/wine-mono/4.6.4/wine-mono-4.6.4.msi", :using => :nounzip
    sha256 "91b7d58177b9a9355edf007dab94535471aebdddae12734ceb4a219d2ecc4152"
  end

  resource "openssl" do
    url "https://www.openssl.org/source/openssl-1.0.2k.tar.gz"
    mirror "https://dl.bintray.com/homebrew/mirror/openssl-1.0.2k.tar.gz"
    sha256 "6b3977c61f2aedf0f96367dcfb5c6e578cf37e7b8d913b4ecb6643c3cb88d8c0"
  end

  resource "libtool" do
    url "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
    mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
    sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"
  end

  resource "jpeg" do
    url "http://www.ijg.org/files/jpegsrc.v8d.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/libj/libjpeg8/libjpeg8_8d.orig.tar.gz"
    sha256 "00029b1473f0f0ea72fbca3230e8cb25797fbb27e58ae2e46bb8bf5a806fe0b3"
  end

  resource "libtiff" do
    url "http://download.osgeo.org/libtiff/tiff-4.0.7.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.7.orig.tar.gz"
    sha256 "9f43a2cfb9589e5cecaa66e16bf87f814c945f22df7ba600d63aac4632c4f019"
  end

  resource "little-cms2" do
    url "https://downloads.sourceforge.net/project/lcms/lcms/2.8/lcms2-2.8.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/l/lcms2/lcms2_2.8.orig.tar.gz"
    sha256 "66d02b229d2ea9474e62c2b6cd6720fde946155cd1d0d2bffdab829790a0fb22"
  end

  resource "libpng" do
    url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.28.tar.xz"
    mirror "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.28/libpng-1.6.28.tar.xz"
    sha256 "d8d3ec9de6b5db740fefac702c37ffcf96ae46cb17c18c1544635a3852f78f7a"
  end

  resource "freetype" do
    url "https://downloads.sourceforge.net/project/freetype/freetype2/2.7.1/freetype-2.7.1.tar.bz2"
    mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.7.1.tar.bz2"
    sha256 "3a3bb2c4e15ffb433f2032f50a5b5a92558206822e22bfe8cbe339af4aa82f88"
  end

  resource "libusb" do
    url "https://github.com/libusb/libusb/releases/download/v1.0.21/libusb-1.0.21.tar.bz2"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libu/libusb-1.0/libusb-1.0_1.0.21.orig.tar.bz2"
    sha256 "7dce9cce9a81194b7065ee912bcd55eeffebab694ea403ffb91b67db66b1824b"
  end

  resource "libusb-compat" do
    url "https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2"
    sha256 "404ef4b6b324be79ac1bfb3d839eac860fbc929e6acb1ef88793a6ea328bc55a"
  end

  resource "webp" do
    url "http://downloads.webmproject.org/releases/webp/libwebp-0.6.0.tar.gz"
    sha256 "c928119229d4f8f35e20113ffb61f281eda267634a8dc2285af4b0ee27cf2b40"
  end

  resource "fontconfig" do
    url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.1.tar.bz2"
    mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/fontconfig/fontconfig-2.12.1.tar.bz2"
    sha256 "b449a3e10c47e1d1c7a6ec6e2016cca73d3bd68fbbd4f0ae5cc6b573f7d6c7f3"
  end

  resource "gd" do
    url "https://github.com/libgd/libgd/releases/download/gd-2.2.4/libgd-2.2.4.tar.xz"
    mirror "https://fossies.org/linux/www/libgd-2.2.4.tar.xz"
    sha256 "137f13a7eb93ce72e32ccd7cebdab6874f8cf7ddf31d3a455a68e016ecd9e4e6"
  end

  resource "libgphoto2" do
    url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.12/libgphoto2-2.5.12.tar.bz2"
    mirror "https://fossies.org/linux/privat/libgphoto2-2.5.12.tar.bz2"
    sha256 "b9bb28990fde45ac385e4851a07dbad2e1250404b535b0a3a3b898bb431e4e2e"
  end

  resource "net-snmp" do
    url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz"
    sha256 "12ef89613c7707dc96d13335f153c1921efc9d61d3708ef09f3fc4a7014fb4f0"
  end

  resource "sane-backends" do
    url "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.25.orig.tar.gz"
    mirror "https://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz"
    sha256 "a4d7ba8d62b2dea702ce76be85699940992daf3f44823ddc128812da33dc6e2c"
  end

  # Fixes some missing headers missing error. Reported upstream
  # https://lists.alioth.debian.org/pipermail/sane-devel/2015-October/033972.html
  resource "sane-backends-patch" do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6dd7790c/sane-backends/1.0.25-missing-types.patch"
    sha256 "f1cda7914e95df80b7c2c5f796e5db43896f90a0a9679fbc6c1460af66bdbb93"
  end

  fails_with :clang do
    build 425
    cause "Clang prior to Xcode 5 miscompiles some parts of wine"
  end

  def openssl_arch_args
    {
      :x86_64 => %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128],
      :i386 => %w[darwin-i386-cc],
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
          system "lipo", "-create", "#{dirs.first}/#{libname}.1.0.0.dylib",
                                    "#{dirs.last}/#{libname}.1.0.0.dylib",
                         "-output", "#{libexec}/lib/#{libname}.1.0.0.dylib"
          rm_f libexec/"lib/#{libname}.a"
        end

        Dir.glob("#{dirs.first}/engines/*.dylib") do |engine|
          libname = File.basename(engine)
          system "lipo", "-create", "#{dirs.first}/engines/#{libname}",
                                    "#{dirs.last}/engines/#{libname}",
                         "-output", "#{libexec}/lib/engines/#{libname}"
        end

        system "lipo", "-create", "#{dirs.first}/openssl",
                                  "#{dirs.last}/openssl",
                       "-output", "#{libexec}/bin/openssl"

        confs = archs.map do |arch|
          <<-EOS.undent
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
        # Enable sub-pixel rendering
        inreplace "include/freetype/config/ftoption.h",
                  "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
                  "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"

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

      resource("libusb-compat").stage do
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              *depflags
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
        system "./configure", "--disable-dependency-tracking",
                              "--prefix=#{libexec}",
                              "--disable-static",
                              "--with-add-fonts=/System/Library/Fonts,/Library/Fonts,~/Library/Fonts",
                              "--localstatedir=#{var}/vendored_wine_fontconfig",
                              "--sysconfdir=#{prefix}",
                              *depflags
        system "make", "install", "RUN_FC_CACHE_TEST=false"
      end

      resource("gd").stage do
        # Poor man's patch as this is a resource
        inreplace "src/gd_gd2.c",
                  "#include <math.h>",
                  "#include <math.h>\n#include <limits.h>"
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
        ln_s "darwin13.h", "include/net-snmp/system/darwin14.h"
        ln_s "darwin13.h", "include/net-snmp/system/darwin15.h"
        ln_s "darwin13.h", "include/net-snmp/system/darwin16.h"

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
          # Cannot have "patch do" here
          Pathname.pwd.install resource("sane-backends-patch")
          system "patch", "-p1", "-i", "1.0.25-missing-types.patch"

          ENV.deparallelize
          system "./configure", "--disable-dependency-tracking",
                                "--prefix=#{libexec}",
                                "--localstatedir=#{var}",
                                "--without-gphoto2",
                                "--enable-local-backends",
                                "--enable-libusb",
                                "--disable-latex",
                                *depflags
          system "make"
          system "make", "install"
        end
      end
    end

    # Help wine find our libraries at runtime
    %w[freetype jpeg png sane tiff].each do |dep|
      ENV["ac_cv_lib_soname_#{dep}"] = (libexec/"lib/lib#{dep}.dylib").realpath
    end

    if build.with? "win64"
      args64 = ["--prefix=#{prefix}"] + depflags
      args64 << "--enable-win64"
      args64 << "--without-x" if build.without? "x11"

      mkdir "wine-64-build" do
        system "../configure", *args64
        system "make", "install"
      end
    end

    args = ["--prefix=#{prefix}"] + depflags
    args << "--with-wine64=../wine-64-build" if build.with? "win64"
    args << "--without-x" if build.without? "x11"

    mkdir "wine-32-build" do
      ENV.m32
      system "../configure", *args
      system "make", "install"
    end
    (pkgshare/"gecko").install resource("gecko-x86")
    (pkgshare/"gecko").install resource("gecko-x86_64")
    (pkgshare/"mono").install resource("mono")
  end

  def caveats
    s = <<-EOS.undent
      You may want to get winetricks:
        brew install winetricks
    EOS

    if build.with? "x11"
      s += <<-EOS.undent

        By default Wine uses a native Mac driver. To switch to the X11 driver, use
        regedit to set the "graphics" key under "HKCU\Software\Wine\Drivers" to
        "x11" (or use winetricks).

        For best results with X11, install the latest version of XQuartz:
          https://xquartz.macosforge.org/
      EOS
    end
    s
  end

  def post_install
    # For fontconfig
    ohai "Regenerating font cache, this may take a while"
    system "#{libexec}/bin/fc-cache", "-frv"

    # For net-snmp
    (var/"db/net-snmp_vendored_wine").mkpath
    (var/"log").mkpath
  end

  test do
    assert_equal shell_output("hostname").chomp, shell_output("#{bin}/wine hostname.exe 2>/dev/null").chomp
    if build.with? "win64"
      assert_equal shell_output("hostname").chomp, shell_output("#{bin}/wine64 hostname.exe 2>/dev/null").chomp
    end
  end
end
