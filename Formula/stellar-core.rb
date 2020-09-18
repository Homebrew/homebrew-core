class StellarCore < Formula
  desc "Backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      tag:      "v14.0.0",
      revision: "eb0153c118c2c4e7913d4e681beadf5cab194b35"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "90e3a2a7ee27cf6bf0fbf73326f31efd5211704a94d6c266dd1860f02734c841" => :catalina
    sha256 "b9a0e969d218908ca36ba35cc71bfd866f8d8c2858d0635f3d63c92ac5d6f91c" => :mojave
    sha256 "4aec90c47396ee3c63b3fc6961e30ce8f7feda4f7b396dbe26aaa483e0b5aac9" => :high_sierra
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
