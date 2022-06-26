class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v19.1.0",
      revision: "e801fd93b2757bebb18ae8b4550afba444d225af"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c18a862a439f80897d2b3c34783cee9994fe1c2fc8c3632b276a3a399ccc6db3"
    sha256 cellar: :any,                 arm64_big_sur:  "59c1c608da2a26ad6552caf23ba92797d748a91b8e9641d820732bd407731c79"
    sha256 cellar: :any,                 monterey:       "249f9213f8921277ff6cb3d5e135dfb478187ed2163f53e07aa1ed62e3d101f7"
    sha256 cellar: :any,                 big_sur:        "6539c8222657db288d71c18f9cac871192b62f5fde9a01bfd4eff63ca19489e8"
    sha256 cellar: :any,                 catalina:       "0009b7fcc0f13e436b90263a40a1c3e699c9a3a3b1ad21f3ad38d2f905dd31e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e21653c184658c398754103254d7fa0841693601b6d560daf95ef6a514dd361c"
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
