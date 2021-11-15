class WxwidgetsAT30 < Formula
  desc "Cross-platform C++ GUI toolkit - Stable Release"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.5.1/wxWidgets-3.0.5.1.tar.bz2"
  sha256 "440f6e73cf5afb2cbf9af10cec8da6cdd3d3998d527598a53db87099524ac807"
  license "wxWindows"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d1dd333ccb2ae7b72737f636a73d5bc36c7b22b83251acb5ed0ca63c54467d7"
    sha256 cellar: :any,                 arm64_big_sur:  "c6c32781b859e025b296306717610853c4dca2e1778511208e11c8add2f256f2"
    sha256 cellar: :any,                 monterey:       "540ed00543ceac8a6c5ce0d7c4e48cdc70bece020ae8d0771c10c0822daa49f4"
    sha256 cellar: :any,                 big_sur:        "97868208219470f640f070daed1ac46216c978022c2737f18dbe23416c19507e"
    sha256 cellar: :any,                 catalina:       "7ada4feb4da76da10e744e6e93e666461bcbb577a7cba23ec1a74e258854c537"
    sha256 cellar: :any,                 mojave:         "0e571023defb572ab776ff364914ce379beede94bb3ea05f0817c89aebe93fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95db78aedb56c161b988c02a398fe1bda727b6a5f3e770fa1367331d7c4748a5"
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "mesa-glu"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webkit",
      "--enable-webview",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    if OS.mac?
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      args << "--with-macosx-version-min=#{MacOS.version}"
      args << "--with-osx_cocoa"
      args << "--with-libiconv"
    end

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxwidgets's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxwidgets and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX

    # Move some files out of the way to prevent conflict with `wxwidgets`
    bin.install "#{bin}/wx-config" => "wx-config-#{version.major_minor}"
    (bin/"wxrc").unlink
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
    Dir.glob(share/"locale/**/*.mo") { |file| add_suffix file, version.major_minor }
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def caveats
    <<~EOS
      To avoid conflicts with the wxwidgets formula, `wx-config` and `wxrc`
      have been installed as `wx-config-#{version.major_minor}` and `wxrc-#{version.major_minor}`.
    EOS
  end

  test do
    system bin/"wx-config-#{version.major_minor}", "--libs"
  end
end
