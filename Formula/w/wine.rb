class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org"
  url "https://dl.winehq.org/wine/source/11.x/wine-11.19.tar.xz"
  sha256 "4820066eda68e553d330239ffc628164a348d1c623e49d058e011c5a7cda95f1"
  license "LGPL-2.1-or-later"
  head "https://gitlab.winehq.org/wine/wine.git", branch: "master"

  livecheck do
    url :head
    regex(/^wine-(\d+\.\d+(?:\.\d+)?(?:-rc\d+)?)$/i)

    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1] }
    end
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "gettext" => :build
  depends_on "nasm" => :build # For PE-side FFmpeg
  depends_on "pkgconf" => :build

  depends_on "alsa-lib"
  depends_on "cups"
  depends_on "dbus"
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "libdrm" => :no_linkage
  depends_on "libpcap"
  depends_on "libusb"
  depends_on "libva" => :no_linkage
  depends_on "libx11"
  depends_on "libxcomposite" => :no_linkage
  depends_on "libxext"
  depends_on "libxfixes" => :no_linkage
  depends_on "libxi" => :no_linkage
  depends_on "libxkbcommon"
  depends_on "libxrandr" => :no_linkage
  depends_on "libxrender" => :no_linkage

  depends_on :linux

  depends_on "mesa"
  depends_on "pcsc-lite"
  depends_on "pulseaudio"
  depends_on "samba"
  depends_on "sane-backends"
  depends_on "sdl2-compat"
  depends_on "systemd" # For udev
  depends_on "vulkan-loader" => :no_linkage
  depends_on "wayland"

  # For FEX
  on_arm do
    depends_on "cmake" => :build
    depends_on "ninja" => :build
    depends_on "python-packaging" => :build
  end

  conflicts_with cask: "wine-stable", because: "both install the same binaries"
  conflicts_with cask: "wine@devel", because: "both install the same binaries"
  conflicts_with cask: "wine@staging", because: "both install the same binaries"

  resource "fex-wine" do
    on_arm do
      url "https://github.com/FEX-Emu/FEX.git",
        tag:      "FEX-2610",
        revision: "14c92681f4d62cf84d901460e0358de09c8847a7"
    end
  end

  resource "gecko-x86" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.tar.xz"
    sha256 "2cfc8d5c948602e21eff8a78613e1826f2d033df9672cace87fed56e8310afb6"

    livecheck do
      url "https://gitlab.winehq.org/wine/wine/-/raw/master/dlls/appwiz.cpl/addons.c"
      regex(/GECKO_VERSION\s+"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.tar.xz"
    version "2.47.4"
    sha256 "fd88fc7e537d058d7a8abf0c1ebc90c574892a466de86706a26d254710a82814"

    livecheck do
      url "https://gitlab.winehq.org/wine/wine/-/raw/master/dlls/appwiz.cpl/addons.c"
      regex(/GECKO_VERSION\s+"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "mono" do
    livecheck do
      url "https://gitlab.winehq.org/wine/wine/-/raw/master/dlls/appwiz.cpl/addons.c"
      regex(/MONO_VERSION\s+"v?(\d+(?:\.\d+)+)"/i)
    end

    on_arm do
      url "https://dl.winehq.org/wine/wine-mono/11.3.0/wine-mono-11.3.0-arm64.tar.xz"
      version "11.3.0"
      sha256 "227cbeef943c71d9bbcbd9d00ea026decbc4ecfb758346f13d2a34a7fd8ecfcf"
    end
    on_intel do
      url "https://dl.winehq.org/wine/wine-mono/11.3.0/wine-mono-11.3.0-x86.tar.xz"
      sha256 "54a1b0111c3fe4b785eae688af94d27e64995707ad648b6fee8000381b80d298"
    end
  end

  resource "llvm-mingw" do
    version "20250920"

    on_arm do
      url "https://github.com/bylaws/llvm-mingw/releases/download/20250920/llvm-mingw-20250920-ucrt-ubuntu-22.04-aarch64.tar.xz"
      sha256 "bce5cc755c613515fd44e1ee9523123d854103abae147571adb645450036274d"
    end

    on_intel do
      url "https://github.com/bylaws/llvm-mingw/releases/download/20250920/llvm-mingw-20250920-ucrt-ubuntu-22.04-x86_64.tar.xz"
      sha256 "8dd8c34fc051a50c2fae86015f35057f8aae93fe1e19b34537ef1269a8b4c772"
    end
  end

  deny_network_access!

  def install
    (buildpath/"llvm-mingw").install resource("llvm-mingw")
    ENV.prepend_path "PATH", "#{buildpath}/llvm-mingw/bin"

    if Hardware::CPU.arm?
      # Homebrew's shim builds with `-mbranch-protection=standard`, so `_start` needs a BTI landing pad
      inreplace "loader/preloader.c", '"mov x0, SP\n\t"', '"bti c\n\t" "mov x0, SP\n\t"', global: false

      common_args = %w[
        -GNinja
        -DENABLE_LTO=False
        -DCMAKE_TOOLCHAIN_FILE=Data/CMake/toolchain_mingw.cmake
        -DBUILD_FEXCONFIG=False
        -DRANGES_NATIVE=OFF
        -DENABLE_JEMALLOC_GLIBC_ALLOC=False
        -DENABLE_CCACHE=False
        -DENABLE_ASSERTIONS=False
        -DCMAKE_DISABLE_FIND_PACKAGE_range-v3=true
      ]

      resource("fex-wine").stage do
        system "cmake", "-S", "Source/Windows/UnixLib", "-B", "build-unixlib",
                        "-GNinja", *std_cmake_args(install_libdir: lib/"wine/aarch64-unix")
        system "cmake", "--build", "build-unixlib"
        system "cmake", "--install", "build-unixlib"

        system "cmake", "-S", ".", "-B", "build-arm64ec",
                    "-DMINGW_TRIPLE=arm64ec-w64-mingw32",
                    *common_args, *std_cmake_args
        system "cmake", "--build", "build-arm64ec"

        system "cmake", "-S", ".", "-B", "build-wow64",
                    "-DMINGW_TRIPLE=aarch64-w64-mingw32",
                    *common_args, *std_cmake_args
        system "cmake", "--build", "build-wow64"

        # Install only necessary files.
        (lib/"wine/aarch64-windows").install(
          "build-arm64ec/Bin/libarm64ecfex.dll" => "xtajit64.dll",
          "build-wow64/Bin/libwow64fex.dll"     => "xtajit.dll",
        )
      end
    end

    ENV.append "LDFLAGS", "-Wl,-rpath,\\$$ORIGIN" # Fix ntdll.so and win32u.so linkage test.
    extra_args = %w[
      --disable-winebth_sys
      --disable-xtajit64
      --without-capi
      --without-gssapi
      --without-krb5
      --without-xxf86vm
      --without-xinerama
      --without-v4l2
      --without-gphoto
      --with-wayland
      --without-opencl
      --without-oss
    ]

    # Skip debug info: the shim drops `-g` but not the `-gdwarf-4` it triggers, and PE builds bypass the shim
    system "./configure", "--disable-tests",
                          "--enable-archs=#{Hardware::CPU.arm? ? "aarch64,arm64ec,i386,x86_64" : "i386,x86_64"}",
                          "CFLAGS=-O2", "CROSSCFLAGS=-O2",
                          *extra_args, *std_configure_args
    system "make"
    system "make", "install-lib", "INSTALL_PROGRAM_FLAGS=-s"

    # Unpacked add-ons are used in place, so they are not copied into every new prefix.
    addons = %w[mono gecko-x86 gecko-x86_64]
    addons.each do |r|
      resource(r).stage { (pkgshare/r.split("-").first/Pathname.pwd.basename).install Pathname.pwd.children }
    end
  end

  test do
    ENV["WINEPREFIX"] = testpath/"wineprefix"

    # Creating the prefix finds the unpacked wine-mono in place
    output = shell_output("WINEDEBUG=trace+mscoree #{bin}/wineboot --init 2>&1")
    system bin/"wineserver", "--wait"
    assert_match "mono runtime is at", output

    hostname = shell_output("hostname -s").chomp.upcase.slice(0, 15) # NetBIOS compatible output.
    assert_equal hostname, shell_output("#{bin}/wine hostname.exe 2>/dev/null").chomp

    system bin/"wine", "reg", "add", "HKCU\\Software\\Homebrew", "/v", "Test", "/d", "brewed", "/f"
    assert_match "brewed", shell_output("#{bin}/wine reg query 'HKCU\\Software\\Homebrew' /v Test 2>/dev/null")
  end
end
