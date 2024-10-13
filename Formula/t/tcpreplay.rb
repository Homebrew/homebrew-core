class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.5.1/tcpreplay-4.5.1.tar.gz"
  sha256 "2de79bfd67ec92ca9ae2ffb50456dd1d53ff40f3fa71b422c65e8062013c9e85"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bcccd1cdd60de8e54a46850f8fb3404cdc94983c6b8239da2268fac5b2fe5516"
    sha256 cellar: :any,                 arm64_sonoma:   "53cefd654ed79a5dd9783f598d97877ddf748251ec6e10c96a15ac8c74cd2166"
    sha256 cellar: :any,                 arm64_ventura:  "6ba083d208f7da09c4b24635bad3fcbecae67f95ac016bdcd6d08880ad1b5c89"
    sha256 cellar: :any,                 arm64_monterey: "9bcef2805cf1df5fb206f40e3f6094bb21766738c3f7c84338693b33e99fa64f"
    sha256 cellar: :any,                 sonoma:         "5d4306409a7a2ab05625d584a7ead36034ab5643cc07534abbda61c53277075e"
    sha256 cellar: :any,                 ventura:        "c5c5eb557b954ac8ba90b74c8be124e3dc8b8da5ce4b4e50958248663797ad04"
    sha256 cellar: :any,                 monterey:       "f1477033f2820e1cde521bf37693a2171ffd9466ad9daa99cb583e30ba3e6999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f67650d054f423e98ef5804aa5e9401ca0895a84e8d0552d97b2e182372b8eb"
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
