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
    rebuild 1
    sha256 "533bdc295f3a0d962fb068a8b85090b532c5ca6417786cbbc6872a2f7e993c7b" => :catalina
    sha256 "fb4d826c3209738d2398cd471fa6dff632c10c0b64fb667eb948717c8cfbdf19" => :mojave
    sha256 "d2d89c1cd64a84dec3728c691f1efbd3f0771dfe2fe931fe73bbbbd174343fd6" => :high_sierra
    sha256 "bb86d15d36d1affafc57ff612ea0a6c88425882bbf5e1bd4cabe5bc1f434a31e" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

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

  def caveats; <<~EOS
    NOTE: the Virtuoso server will start up several times on port 1111
    during the install process.
  EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end
