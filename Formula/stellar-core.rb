class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v17.3.0",
      revision: "0b4c12a37b207dff0bfe5785ead403a000ca0f13"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0f4a64af4d39cd840a59ff1883688c2fe38ba239484c34591006d0c76e837984"
    sha256 cellar: :any, big_sur:       "790a62b146163d9fbe795a272cd44c0393328d16e81b3b933369af1118df7092"
    sha256 cellar: :any, catalina:      "bc4b019510fbff3711db51beb7cfb74f63a5fa215c0f068cae657fe307202609"
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
