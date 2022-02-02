class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.4.0/tcpreplay-4.4.0.tar.gz"
  sha256 "a3b125c0319bd096d68f821c4a08051b2d3d9278bac6fe18cfe3c9201703a567"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e39e3a00e0da1a3fd7fb9371cf4641e742c3ad4392922c04111072e49bc57d1e"
    sha256 cellar: :any,                 arm64_big_sur:  "f03bfb5f1b281de0f696c1188c97ab97a7919b57760ba49d58c797cea8f63b7b"
    sha256 cellar: :any,                 monterey:       "a407650e9a9d593493e12fdc7a6b58cd2171682c695f5b814e3dc3f38f9e805c"
    sha256 cellar: :any,                 big_sur:        "6d7199e6c205cb9112f703d3668402a0f9f4b673beaf4fc4ac5ee98a85b62942"
    sha256 cellar: :any,                 catalina:       "a825697a2cf4da19b2478ca04c0299542a49bbb01bf36b7eb2babbd52ffda3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35fb404fef44fd2da9189cb73b4c369fe7a07a26590eaa79e87e9f0639311f94"
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
