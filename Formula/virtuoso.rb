class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com/wiki/main/"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.5.1/virtuoso-opensource-7.2.5.tar.gz"
  # Upstream pushed a hot-fix retag of 7.2.5 as 7.2.5.1.
  # This explicit version should be safe to remove next release.
  version "7.2.5.1"
  sha256 "826477d25a8493a68064919873fb4da4823ebe09537c04ff4d26ba49d9543d64"
  revision 1
  # HEAD is disabled as the below, required patches are not compatible.

  bottle do
    cellar :any
    sha256 "c4904ae739141d51638c3f33064c85498c20d32169053daa61203ff6706c1fa8" => :catalina
    sha256 "3a2375ce75d34e6fa2568aeb4bc3ac0239a4052c811eb3afeb7536166b05e67b" => :mojave
    sha256 "3abcc2f1444324d675af9014ac20555124c875d7e9a4ba9b021fd1ad7c570845" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  conflicts_with "unixodbc", :because => "Both install `isql` binaries."

  skip_clean :la

  # Support OpenSSL 1.1
  patch do
    url "https://sources.debian.org/data/main/v/virtuoso-opensource/7.2.5.1+dfsg-2/debian/patches/ssl1.1.patch"
    sha256 "9fcaaff5394706fcc448e35e30f89c20fe83f5eb0fbe1411d4b2550d1ec37bf3"
  end

  # TLS 1.3 compile error patch.
  # This also updates the default TLS protocols to allow TLS 1.3.
  patch do
    url "https://github.com/openlink/virtuoso-opensource/commit/67e09939cf62dc753feca8381396346f6d3d4a06.patch?full_index=1"
    sha256 "485f54e4c79d4e1e8b30c4900e5c10ae77bded3928f187e7e2e960d345ca5378"
  end

  def install
    # We patched configure.ac on stable so need to rerun the autogen.
    system "./autogen.sh"
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
