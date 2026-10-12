class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org"
  url "https://dl.winehq.org/wine/source/11.x/wine-11.18.tar.xz"
  sha256 "c6282f6d4daecf11f3ab9f9a2b6c598f67be7e28c363ba2cae8a3c44b611e7a4"
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
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkgconf" => :build

  depends_on "alsa-lib"
  depends_on "ffmpeg"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "libgphoto2"
  depends_on "libpcap"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxcomposite" => :no_linkage
  depends_on "libxext"
  depends_on "libxkbcommon"

  depends_on :linux

  depends_on "opencl-icd-loader"
  depends_on "pcsc-lite"
  depends_on "pulseaudio"
  depends_on "samba"
  depends_on "sane-backends"
  depends_on "systemd" # For udev
  depends_on "unixodbc"
  depends_on "vulkan-loader" => :no_linkage
  depends_on "wayland"

  on_intel do
    depends_on "nasm" => :build # For FFmpeg

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
  end

  conflicts_with cask: "wine-stable", because: "both install the same binaries"
  conflicts_with cask: "wine@devel", because: "both install the same binaries"
  conflicts_with cask: "wine@staging", because: "both install the same binaries"

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

  deny_network_access!

  def install
    # Homebrew's shim builds with `-mbranch-protection=standard`, so `_start` needs a BTI landing pad
    if Hardware::CPU.arm?
      inreplace "loader/preloader.c", '"mov x0, SP\n\t"', '"bti c\n\t" "mov x0, SP\n\t"', global: false
    end

    ENV.append "LDFLAGS", "-Wl,-rpath,\\$$ORIGIN" # Fix ntdll.so and win32u.so linkage test.
    extra_args = %w[
      --with-gstreamer
      --with-vulkan
      --without-v4l2
      --without-capi
    ]

    # Skip debug info: the shim drops `-g` but not the `-gdwarf-4` it triggers, and PE builds bypass the shim
    system "./configure", "--disable-tests",
                          "--enable-archs=#{Hardware::CPU.arm? ? "aarch64,arm64ec" : "i386,x86_64"}",
                          "--with-mingw=#{formula_opt_bin("llvm")}/clang",
                          "CFLAGS=-O2", "CROSSCFLAGS=-O2",
                          *extra_args, *std_configure_args
    system "make"
    system "make", "install-lib"

    # Unpacked add-ons are used in place, so they are not copied into every new prefix
    resources.each do |r|
      r.stage { (pkgshare/r.name.split("-").first/Pathname.pwd.basename).install Pathname.pwd.children }
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
