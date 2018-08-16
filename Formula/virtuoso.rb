class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.5.1/virtuoso-opensource-7.2.5.tar.gz"
  # Upstream pushed a hot-fix retag of 7.2.5 as 7.2.5.1.
  # This explicit version should be safe to remove next release.
  version "7.2.5.1"
  sha256 "826477d25a8493a68064919873fb4da4823ebe09537c04ff4d26ba49d9543d64"

  bottle do
    cellar :any
    sha256 "29dc5f3eb68e0f8a9d433766293fbce6828f8ec5ec541428f9b0f00c6d1be26c" => :high_sierra
    sha256 "643818e6d36ad7a22b9d91b68f3eb16826f140415e23da30b96abb0858e73058" => :sierra
    sha256 "76d5201d062e528bff78d3c42b9f4d3e8f8b041bfdc9a0881546572cdad87717" => :el_capitan
    sha256 "4a2d5b2a0c81caa351a8388c781c189f36a45245479cd04584284668ca6a9ba6" => :yosemite
    sha256 "feba222422d9882640afbd5d62f2e3a5cd3d8f9ecf00bb31c399bee5f685a53a" => :mavericks
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", :branch => "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl"

  conflicts_with "unixodbc", :because => "Both install `isql` binaries."

  skip_clean :la

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    NOTE: the Virtuoso server will start up several times on port 1111
    during the install process.
  EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end
