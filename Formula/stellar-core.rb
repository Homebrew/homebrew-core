class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v17.0.0",
      revision: "096f6a766ed6aa08e13519371e842b90f01df841"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    sha256 cellar: :any, big_sur:  "e2a7541f0ceefe4ce94e383b7c47220204621388652792d348ee9672ec9c4537"
    sha256 cellar: :any, catalina: "b61387790d775918af0154bb689576d13c7f9c66eef343863907feba8bebca54"
    sha256 cellar: :any, mojave:   "a15488f5ed2c00c4eb8b5497bfe86ae370a969eb845b0a5b8ebfc24863acc81b"
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
