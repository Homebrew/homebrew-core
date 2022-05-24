class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.6.1/virtuoso-opensource-7.2.6.tar.gz"
  sha256 "38fd3c037aef62fcc7c28de5c0d6c2577d4bb19809e71421fc42093ed4d1c753"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "80cff43493d2981f14ec84848d5951a239a1ffe307bc030e7fed2ebc48234303"
    sha256 cellar: :any,                 arm64_big_sur:  "07dd74a255eadcb7bf6cc41d3e07445a992069e5ab9072dc24a8f02fd98dcf74"
    sha256 cellar: :any,                 monterey:       "dfd970140bb4e7a212d2fa8c4be8a45a75d643fa247ed185d1fc6607ff044e76"
    sha256 cellar: :any,                 big_sur:        "d35c507e655a9b900986b609bb232f30c811cbfb4f3ec20d60d1146059ba5305"
    sha256 cellar: :any,                 catalina:       "bb672169382bf5faa77845765420adc91f5af1e46239e1f9d45d187b2f335570"
    sha256 cellar: :any,                 mojave:         "e19a2320912ff23b8f0a4926ee3c830d1bbbc9388fbe21634cbecf919e17f708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d396498868d1529455ff98c3432df539f5c0acecc2f807c7d5f49e1cf10d3267"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build

  on_linux do
    depends_on "net-tools" => :build
  end

  conflicts_with "unixodbc", because: "both install `isql` binaries"

  skip_clean :la

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      NOTE: the Virtuoso server will start up several times on port 1111
      during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end
