class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v15.3.0",
      revision: "6b99ef893c7f13f22c7c72a7f66ea912aeb4ad73"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    sha256 cellar: :any, big_sur:  "35e9457b2e517326f149db3c0608d08a37f1bd906fa0dd5a18d1f754bb420027"
    sha256 cellar: :any, catalina: "7b0f57cf2aa959f7841e9c7ba74998843701b72c79e91dd48dd33450320610dc"
    sha256 cellar: :any, mojave:   "f897d9e2d87b5fcbc7b1140e87649a3849b6fe7a3ff4ceec4f3dc8ec8687cb4c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "parallel" => :test
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-postgres"
    system "make", "install"
  end

  test do
    system "#{bin}/stellar-core", "test",
      "'[bucket],[crypto],[herder],[upgrades],[accountsubentriescount]," \
      "[bucketlistconsistent],[cacheisconsistent],[fs]'"
  end
end
