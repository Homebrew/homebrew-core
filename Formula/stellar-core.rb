class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.7.0",
      revision: "7249363c60e7ddf796187149f6a236f8ad244b2b"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "232a88e9183d689fe28518a397000a5d7a422abbf33521a07c87f1cf0b4fec97"
    sha256 cellar: :any,                 arm64_monterey: "db753ca7609c40481550a0c8c3aec7a17f7f2a4d1efc172322acbafc95c48635"
    sha256 cellar: :any,                 arm64_big_sur:  "1f63554a2afeb277da1b7ae09294ab73702a0c0b234b87d64d1475f8a36e0f14"
    sha256 cellar: :any,                 ventura:        "a36974492e7e2b8af18038b05ee0a72c354c5a95ea597a25e59d05b7a30187e3"
    sha256 cellar: :any,                 monterey:       "e5608493a64ffe1232cdbbbc51f4889907021af5bee3be46848c0226ee8e0c25"
    sha256 cellar: :any,                 big_sur:        "4d3e0bcb863eecf906ddf346d2b282362b653492682749eb49c4abf2992fd64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9673057280dd7828e95ce93ed0713c3f4a0c00da52b859a5b755f9d1a4b336d"
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
