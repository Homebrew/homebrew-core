class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v17.1.0",
      revision: "fbc0325759ff75dd250cb5e175978669cdb4e90a"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    sha256 cellar: :any, big_sur:  "5513cb2162bd6b3022a5a73d02bd29c777990ea4b399a34d30df96438734ef2c"
    sha256 cellar: :any, catalina: "5e985581748fbbdc299a8f4e6e99116b19cd71d5047e21060d61fcf7f61a03bb"
    sha256 cellar: :any, mojave:   "b581b4584522263215991bef051f745715a34ff892db8072999bd6d0eb5c38f1"
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

  on_linux do
    depends_on "gcc"
  end

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.22' not found
  # Upstream has explicitly stated gcc-5 is too old: https://github.com/stellar/stellar-core/issues/1903
  fails_with gcc: "5"

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
