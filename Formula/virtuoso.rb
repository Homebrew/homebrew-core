class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.6.1/virtuoso-opensource-7.2.6.tar.gz"
  sha256 "38fd3c037aef62fcc7c28de5c0d6c2577d4bb19809e71421fc42093ed4d1c753"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, big_sur:     "7f6b30ca0a581875e7efede66e4d57c6415b8ae1148a7294eb24cc89f556f2d6"
    sha256 cellar: :any, catalina:    "c4904ae739141d51638c3f33064c85498c20d32169053daa61203ff6706c1fa8"
    sha256 cellar: :any, mojave:      "3a2375ce75d34e6fa2568aeb4bc3ac0239a4052c811eb3afeb7536166b05e67b"
    sha256 cellar: :any, high_sierra: "3abcc2f1444324d675af9014ac20555124c875d7e9a4ba9b021fd1ad7c570845"
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
