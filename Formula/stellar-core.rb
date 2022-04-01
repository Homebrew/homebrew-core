class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v18.5.0",
      revision: "d387c6a710322135ac076804490af22c4587b96d"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0d345d8e571beb4937082694c062a553e9fb0bddbf5cc79a3c5ff8661938a6eb"
    sha256 cellar: :any,                 arm64_big_sur:  "665e205c4d9c4ba444ed43f94d8ccc5f898becbd29e2068fbae9c0f52664e6eb"
    sha256 cellar: :any,                 monterey:       "92bd2a6c61961089a8308ce68d23cef5288e8ca86e9a73e62c53c344f3983ab1"
    sha256 cellar: :any,                 big_sur:        "1e01e46e0d0ddd087caafa140a1a738b38ba0ca7271c7443a999f5edc659acb2"
    sha256 cellar: :any,                 catalina:       "f4b8f02dca775eaf9dded2504d62f72933ff5fcef8875b2a90ae81698c2323ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6cc582b0bb8a2636bb071bfaba8abe0ae0f7536f9459d07069364befff4f5ad"
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
  depends_on macos: :catalina # Requires C++17 filesystem

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
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
