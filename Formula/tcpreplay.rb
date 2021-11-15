class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.3.4/tcpreplay-4.3.4.tar.gz"
  sha256 "ee065310806c22e2fd36f014e1ebb331b98a7ec4db958e91c3d9cbda0640d92c"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbfff741e443b06465748f494eb4fa2147e06860cd986c349ff907130e2b8a1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ff671547bf0a9b988a01d6af0ed8c387b62c79097a6915aadc50af2d11c330b"
    sha256 cellar: :any,                 monterey:       "aaf944f4924fc025530933d1d815fceee0277e91a630a4d61bd1cf807acc395c"
    sha256 cellar: :any,                 big_sur:        "55ffb5347204c187b5151181efef39586b052340e8dc40635809fc8eb36ed0e6"
    sha256 cellar: :any,                 catalina:       "2268f0760672a512de278ea4c686b976e75589bb374663c1b9ecbf49ada784ca"
    sha256 cellar: :any,                 mojave:         "7724d4f1f79cd07a77b430e63e541486d8f666785215dfd898ba54ff2aa35186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12598cf97924b496cfc7558b4b74e6c26a9334e89bbf2fb8ec497ea2ab8a509f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-link
    ]

    args << if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      # The SDK is currently found using `xcrun --sdk macosx<V>` starting with
      # input `--with-macosx-sdk=<V>` and then going from older 10.8 onward.
      # On ARM, for Big Sur 11.4 the correct SDK is 11.3 (as of 2021-07-11);
      # however, the logic picks 10.15, which causes configure failure.
      # As a workaround, we remove all 10.x versions from SDK detection logic.
      #
      # Check in next release if the workaround can be removed.
      # Upstream issue: https://github.com/appneta/tcpreplay/issues/668
      inreplace "configure.ac", /(\$with_macosx_sdk\s+)(?:10\.\d+\s+)+/, "\\1" if Hardware::CPU.arm?

      "--with-macosx-sdk=#{MacOS.version}"
    else
      "--with-libpcap=#{Formula["libpcap"].opt_prefix}"
    end

    system "./autogen.sh"
    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
