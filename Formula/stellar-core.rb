class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v18.0.3",
      revision: "f3baea678aa966bf60ac0c7a8ecfebbaba01b008"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8f045778207dc06f198bd8b022efcb113f7e59ea94c19d67f433a84a05b3399b"
    sha256 cellar: :any, big_sur:       "3e7a0e89654c92d3f99b3b18c94f066b1a292ba5daf7c54102df7b8abdbfeafe"
    sha256 cellar: :any, catalina:      "25bbe642d601ffd44e776f4b10cf12eb896ec3f4e2b9fc5616885d446876fdc7"
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
