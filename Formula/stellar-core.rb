class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.8.0",
      revision: "040a29c5123fcdd8d8c4dc4f3f7a3d496627f4b2"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ca811fb5eb3dd97313515b1f010ae00f11dc49c068959d92f0eda2ad7e44b604"
    sha256 cellar: :any,                 arm64_monterey: "58d2dd1671bb482b7e04583166ed0bd96bc3d39335d228edc8c44b8e99f1f8cc"
    sha256 cellar: :any,                 arm64_big_sur:  "07a12dc1d822324a0cd5f7304601b741871cd21567d42da6d276285f928d9805"
    sha256 cellar: :any,                 ventura:        "ae887f2ea1455abaf0c54ca7aaa9994b843984e1f76aa6a0f6067804d211d9b7"
    sha256 cellar: :any,                 monterey:       "ec83eb9252c6b3e1bcf32d0172d8d8f97c1d6685b3835fea8436d64c585935fb"
    sha256 cellar: :any,                 big_sur:        "0f4ef7b81318d6f099cb1389aea7272b759dd87b35507486073a40bd522ca494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a53af318077dc316a5ab90b8f4c9edf1095ff765b75b51eca9b68878479762b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Bison 3.0.4+
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
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
    test_categories = %w[
      accountsubentriescount
      bucketlistconsistent
      topology
      upgrades
    ]
    system "#{bin}/stellar-core", "test",
      test_categories.map { |category| "[#{category}]" }.join(",")
  end
end
