class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https://ta-lib.org/"
  url "https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz"
  sha256 "9ff41efcb1c011a4b4b6dfc91610b06e39b1d7973ed5d4dee55029a0ac4dc651"

  bottle do
    cellar :any
    rebuild 1
    sha256 "da70ac36643d428f0e4742c5bed21a674a9a5585765c764cf11e6e53a9086041" => :catalina
    sha256 "db4ba23b6c0a235b2478416040a2321e305fe2f57810e87d6b5400addc0c3eea" => :mojave
    sha256 "5d53fe57d49e5c60b8ea81e633e502e73569e191f16fa36aabb39085ffe2581a" => :high_sierra
    sha256 "0229a85f2bdaa14baabe840b12f50eed8eb88233d13bcdb0424c5ab6fc2a4a6c" => :sierra
    sha256 "3b5927cdb5f69cdc57d8ecbdf5b6fc95a5b6aad7c626c79d1893f2d824030e65" => :el_capitan
    sha256 "bb40b6d09be26ee497aae27abea5808730af29e6387fa347996eae49c32c448d" => :yosemite
    sha256 "da1457eb5a09c71f90da185b954aff3d399e61a20ff78ad0bd9d177ad11ad1b7" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "src/tools/ta_regtest/.libs/ta_regtest"
  end

  test do
    system "#{bin}/ta_regtest"
  end
end
