class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.4.2/virtuoso-opensource-7.2.4.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/virtuoso/virtuoso/7.2.4.2/virtuoso-opensource-7.2.4.2.tar.gz"
  sha256 "028075d3cf1970dbb9b79f660c833771de8be5be7403b9001d6907f64255b889"

  bottle do
    cellar :any
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
    ENV.m64 if MacOS.prefer_64_bit?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    NOTE: the Virtuoso server will start up several times on port 1111
    during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end
