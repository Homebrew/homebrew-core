class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.4.1/tcpreplay-4.4.1.tar.gz"
  sha256 "cb67b6491a618867fc4f9848f586019f1bb2ebd149f393afac5544ee55e4544f"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "246a822476aafe55e646650027017108c6c262498b7570458237d9dc1c66e139"
    sha256 cellar: :any,                 arm64_big_sur:  "8f57fe87399c72f9179e651910e513c2238b0d04dc717358a37115aa6c1d8b0a"
    sha256 cellar: :any,                 monterey:       "a1b2bb76d38e74c2eb3fbdc23ddab71e76f993a254199f73a21ddc8eb63d97b4"
    sha256 cellar: :any,                 big_sur:        "d4ad05fa1d80f60b347813c1c300745c1cac288c428acbae2eae782fff538b86"
    sha256 cellar: :any,                 catalina:       "b650d22c9a17d3e137a7e1f118d72d8ea4d57d8c4e33d7a3ae1165534df4e390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "648a5148de83dea2991519c912f86c7c41a144392294f418e7db95cb8f09f560"
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
      --with-libdnet=#{Formula["libdnet"].opt_prefix}
    ]

    args << if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

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
