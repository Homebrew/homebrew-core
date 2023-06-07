class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.11.0",
      revision: "7fb6d5e8858fed6ea365f8717b0266635f578477"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d6a5251a39f886dcb2768a0c898c8a8da9d737dff2a4ec5552a6c5de98f0d76"
    sha256 cellar: :any,                 arm64_monterey: "b3c673fd16bf2308ad3ae791260e89052cd9815c5d374d9866ce056bd1705e26"
    sha256 cellar: :any,                 arm64_big_sur:  "ea376059af9388faf6ecb671ca344f869f5d3e6d260179c9a4367bbba80ab28a"
    sha256 cellar: :any,                 ventura:        "0458e5e86e4f6706e1dfc87f169f66c48d11edbd79f07d854931b13780f2a8d0"
    sha256 cellar: :any,                 monterey:       "77ad1e096da24f0123d5d184d5f1367ea5da0505f0e58595b674cc4a3251762d"
    sha256 cellar: :any,                 big_sur:        "8a5d9930a65073a5dab783a8da2b0097146a53e2abcd5fae4b758518efe56257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b4de83d3d820012b3c0f55bd6e4a35b5b78d2ec961abf9c699b019ff95009b"
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
