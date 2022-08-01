class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.3.0",
      revision: "9ce6dc4e9889ce86083c0e3ba2e773e0ff2ced3a"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1448e110ca53e698c17c8b03f9624b97cd27a5b850b873a68a2d431f768ee98e"
    sha256 cellar: :any,                 arm64_big_sur:  "3e2d3cb23a83a67588967e7fc6f469a53a6ae368b05c3295dfe7559dabb90306"
    sha256 cellar: :any,                 monterey:       "28bce77a35079c3da0c3553dec91bd0282f29f55a98f015a1e66b04dff37828c"
    sha256 cellar: :any,                 big_sur:        "243a2fcfe423ba6a6023b70df32d044095bfcb5545d571f3ccf63b9d3bfd2f87"
    sha256 cellar: :any,                 catalina:       "c2b043f20dbe8038906076e402cfab67b41f50a97236a60a4b5ab46f51f99721"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "parallel" => :test
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "libsodium"
  depends_on macos: :catalina # Requires C++17 filesystem
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libunwind"
  end

  # https://github.com/stellar/stellar-core/blob/master/INSTALL.md#build-dependencies
  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

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
