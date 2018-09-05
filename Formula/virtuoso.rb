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
    sha256 "699c3f1bf4711cc0ec3a0c81f69047fcf721f4f2a38db629858f7b155217d1f8" => :mojave
    sha256 "b01c3c149c4f025ea1456fc5a5d3c5ca68eb6d99797226e35204dbd80cb43cb1" => :high_sierra
    sha256 "b7df838df0d82a95a0f7fc40177b5fb94fb0e47559d559c75baa473af7956b92" => :sierra
    sha256 "4bacfd4bbaf1d4a048a68f4993b06fc2b6a9a2c1145f9cea78fb8fbff23166a1" => :el_capitan
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
