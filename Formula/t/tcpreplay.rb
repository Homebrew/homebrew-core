class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.4.4/tcpreplay-4.4.4.tar.gz"
  sha256 "44f18fb6d3470ecaf77a51b901a119dae16da5be4d4140ffbb2785e37ad6d4bf"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d4ecb5611be8412c3c0a0c4aa1b7b1ba332b0dc6a5012085db1df36df88d102"
    sha256 cellar: :any,                 arm64_monterey: "161b8a9f9f36d57d9e202e048a6268ece22766d77ace117db804e2e4a4c46bfa"
    sha256 cellar: :any,                 arm64_big_sur:  "d380ca5958c854092c1043730013f1ca23d3236fca729fb40823f306c4287abe"
    sha256 cellar: :any,                 ventura:        "840cf96e8e0123dfdae2837c2636065634f3a4b49073eefd5979e50d1d29c635"
    sha256 cellar: :any,                 monterey:       "026d9a462e83ef10af1aa075b05d833cb52063c263a5675242c85caa2d4ff544"
    sha256 cellar: :any,                 big_sur:        "544f608fe29cbb7259f7711d7e18f1c414de49f5dffc4df74d1f8087e123a845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef8f50af0ac4fe0c84beaea014c71cdd881e954a00cc0de72138b98c9de169b4"
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

    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
