class Wine < Formula
  desc "Run Windows applications without a copy of Microsoft Windows"
  homepage "https://www.winehq.org"
  url "https://dl.winehq.org/wine/source/11.x/wine-11.15.tar.xz"
  sha256 "5046f36dae210b198ea69792774d4401feed975d465eca6c251c9394400ec272"
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
  depends_on "mingw-w64" => :build
  depends_on "nasm" => :build # For FFmpeg
  depends_on "opencl-headers" => :build
  depends_on "pkgconf" => :build

  depends_on "alsa-lib"
  depends_on arch: :x86_64 # Wine on arm64 would build arm64 PE binaries, which may not be what user expects.
  depends_on "cups"
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "libgphoto2"
  depends_on "libpcap"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxcomposite" => :no_linkage
  depends_on "libxext"
  depends_on "libxkbcommon"
  depends_on "libxrandr"

  depends_on :linux

  depends_on "mesa"
  depends_on "opencl-icd-loader"
  depends_on "pcsc-lite"
  depends_on "pulseaudio"
  depends_on "samba"
  depends_on "sane-backends"
  depends_on "sdl2-compat"
  depends_on "systemd" # For udev
  depends_on "unixodbc"
  depends_on "vulkan-loader" => :no_linkage
  depends_on "wayland"

  conflicts_with cask: "wine-stable", because: "both install the same binaries"
  conflicts_with cask: "wine@devel", because: "both install the same binaries"
  conflicts_with cask: "wine@staging", because: "both install the same binaries"

  resource "mono" do
    url "https://dl.winehq.org/wine/wine-mono/11.3.0/wine-mono-11.3.0-x86.msi"
    sha256 "df2dfc1665c2511882e7cabd56eafd0c0a3d94e5a7e86f969277f6c189d418d3"

    livecheck do
      url "https://dl.winehq.org/wine/wine-mono/"
      regex(/wine-mono[._-]v?(\d+(?:\.\d+)+)\.msi/i)
    end
  end

  resource "gecko-x86" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.msi"
    sha256 "26cecc47706b091908f7f814bddb074c61beb8063318e9efc5a7f789857793d6"

    livecheck do
      url "https://dl.winehq.org/wine/wine-gecko/"
      regex(/wine-gecko[._-]v?(\d+(?:\.\d+)+)-x86\.msi/i)
    end
  end

  resource "gecko-x86_64" do
    url "https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.msi"
    sha256 "e590b7d988a32d6aa4cf1d8aa3aa3d33766fdd4cf4c89c2dcc2095ecb28d066f"

    livecheck do
      url "https://dl.winehq.org/wine/wine-gecko/"
      regex(/wine-gecko[._-]v?(\d+(?:\.\d+)+)-x86_64\.msi/i)
    end
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,\\$$ORIGIN" # Fix ntdll.so and win32u.so linkage test.
    extra_args = []

    extra_args << "--with-gstreamer"
    extra_args << "--with-vulkan"
    extra_args << "--without-v4l2"
    extra_args << "--without-capi"

    system "./configure", "--disable-tests",
                          "--enable-archs=i386,x86_64",
                          *extra_args, *std_configure_args
    system "make", "install"

    # Reduce prefix size
    rm_r buildpath.glob(prefix/"**/*.a")

    system Formula["mingw-w64"].bin/"i686-w64-mingw32-strip", "--strip-unneeded",
                              *lib.glob("wine/i386-windows/*.{dll,exe}")
    system Formula["mingw-w64"].bin/"x86_64-w64-mingw32-strip", "--strip-unneeded",
                              *lib.glob("wine/x86_64-windows/*.{dll,exe}")
    system "strip", "--strip-unneeded", *lib.glob("wine/x86_64-unix/*.so")

    # Each new prefix looks for gecko and mono here, and attempts installing
    # a few .msi's if not found. So they are put here to reduce prefix footprint.
    (pkgshare/"gecko").install resource("gecko-x86")
    (pkgshare/"gecko").install resource("gecko-x86_64")
    (pkgshare/"mono").install resource("mono")
  end

  test do
    hostname = shell_output("hostname -s").chomp.upcase.slice(0, 15) # NetBIOS compatible output.
    assert_match shell_output("#{bin}/wine hostname.exe 2>/dev/null").chomp, hostname
  end
end
