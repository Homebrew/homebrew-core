class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.8.0",
      revision: "040a29c5123fcdd8d8c4dc4f3f7a3d496627f4b2"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9e75ddbf596a91dee7378d95e15d99cbbd6edafaabc73399af7d434682b08bb9"
    sha256 cellar: :any,                 arm64_monterey: "9e5b0ddf44c195aed7ddf348f85df0ddfef21777e6e7513b5e91246c0a04852a"
    sha256 cellar: :any,                 arm64_big_sur:  "bd2ef086cb6d8226113681cbe31a86e36ce687562b3dff5dd4ab0db87acd9949"
    sha256 cellar: :any,                 ventura:        "34561458759236ed5006ac1149f3828d1b5dc7692f97b1d877560f0928599bc3"
    sha256 cellar: :any,                 monterey:       "fe34f8fe4eb055461003912a88886bc0845982b7d6977f5f9eceb6991b98e6d2"
    sha256 cellar: :any,                 big_sur:        "0b9264ad417b3bc93b530e26546b731d61b1b5047a64ce94deb205e75e03a322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a97a1d2e46c068c4fffa52239fc46266772aa15511a59ea20fb3affb634a9c83"
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
