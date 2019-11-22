class StellarCore < Formula
  desc "The backbone of the Stellar (XLM) network"
  homepage "https://www.stellar.org/"
  url "https://github.com/stellar/stellar-core.git",
      :tag      => "v12.1.0",
      :revision => "8afe57913a08deffa247d7b5f837e0b28a54b864"
  head "https://github.com/stellar/stellar-core.git"

  bottle do
    cellar :any
    sha256 "02a0d4e82e45367e4622e517e703e49b3e6af4b80a24a36741cf0616638c98d7" => :catalina
    sha256 "bda5192d4d3fe8307cbdcfccdebb8c751b3d899d4ccea3f3cbe14a6141d5cfe8" => :mojave
    sha256 "83ad5766310af3d84f485a66c233cef5c096029082a14e3c278d5edc9ff2d50e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "parallel" => :test
  depends_on "libpqxx"
  depends_on "libsodium"

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
    system "#{bin}/stellar-core", "test", "'[bucket],[crypto],[herder],[upgrades],[accountsubentriescount],[bucketlistconsistent],[cacheisconsistent],[fs]'"
  end
end
