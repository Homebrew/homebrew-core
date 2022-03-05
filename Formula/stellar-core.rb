class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v18.4.0",
      revision: "13ef7c0f3ae85306ddb8633702c649c8f6ee94bb"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "048413c08407db38f016438911cc24498d0919b8cb8a09196f1ddcc31b5ddb76"
    sha256 cellar: :any, arm64_big_sur:  "c8d41192a8f14e1990eb9110696253a0c2c24e3fa8f9532acc00596a5b356f45"
    sha256 cellar: :any, monterey:       "2d1d408bf2741d1c8af2c997181d29848a862f1f49dbbf057417dd76ab4ae010"
    sha256 cellar: :any, big_sur:        "b9802e2eb2a7edc26f70184cae0f882807b1ffe86cec3b5c5f49e6ce84521e5c"
    sha256 cellar: :any, catalina:       "c1b97b9a1f273caee556d6f24dfb096f21d3955ee25cdadf81ba06e019f3165f"
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

  # Fix GCC error: xdrpp/marshal.cc:24:59: error: 'size' is not a constant expression.
  # Remove when release has updated `xdrpp` submodule.
  patch do
    url "https://github.com/xdrpp/xdrpp/commit/b4979a55fe19b1fd6b716f6bd2400d519aced435.patch?full_index=1"
    sha256 "5c74c40b0e412c80d994cec28e9d0c2d92d127bc5b9f8173fd525d2812513073"
    directory "lib/xdrpp"
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
