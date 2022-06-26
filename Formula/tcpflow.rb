class Tcpflow < Formula
  desc "TCP/IP packet demultiplexer"
  homepage "https://github.com/simsong/tcpflow"
  url "https://downloads.digitalcorpora.org/downloads/tcpflow/tcpflow-1.6.1.tar.gz"
  sha256 "436f93b1141be0abe593710947307d8f91129a5353c3a8c3c29e2ba0355e171e"
  license "GPL-3.0"

  livecheck do
    url "https://downloads.digitalcorpora.org/downloads/tcpflow/"
    regex(/href=.*?tcpflow[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e25618ff226f705ee66793309e8f1d01b9adf8e51f1930e5c3ff52fb904cd28"
    sha256 cellar: :any,                 arm64_big_sur:  "45666c536a212cbc2b76a6663e051f432e4b82910a440d5fa6cebad4562e70f9"
    sha256 cellar: :any,                 monterey:       "a964e150a0429750379df21f3a1e24b4ac336ca15b66cffdbeaba98e3edc35c4"
    sha256 cellar: :any,                 big_sur:        "ec65cbfeff09cd48c9accca03cf14a733034b96f0d01d47cbcf43ef9e0e859de"
    sha256 cellar: :any,                 catalina:       "78b9e40f778060e2a0a277dfa1ff2d3ee720be679f8ade7b98e274ace2a05e7c"
    sha256 cellar: :any,                 mojave:         "752820d85c73654edd4b2eef81a36d6d3be542e8cb6f7f62af7906b0740ba98f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0a2015d8bb5ac2ddca983dd577325a59288527fc77309fe628cdf7a6e55922e"
  end

  head do
    url "https://github.com/simsong/tcpflow.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
