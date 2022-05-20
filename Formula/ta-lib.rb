class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https://ta-lib.org/"
  url "https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz"
  sha256 "9ff41efcb1c011a4b4b6dfc91610b06e39b1d7973ed5d4dee55029a0ac4dc651"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "42dab227aceff238ecc3b475ddffaa3d54e3da69a89c5aae08b4b4463ab2f0e9"
    sha256 cellar: :any,                 arm64_big_sur:  "c251da6ef6b483906eaa894dd86c19da3200acca00d6fab5f45522ff4b2681f1"
    sha256 cellar: :any,                 monterey:       "6c7ef4d661dfe335e942a2086ff237e13a7205a74bda91920bb265f9b5877d6a"
    sha256 cellar: :any,                 big_sur:        "363867dbdc2b177b4efd51265df3c9154547d6aa9056ab78d83bfc9776aebb01"
    sha256 cellar: :any,                 catalina:       "da70ac36643d428f0e4742c5bed21a674a9a5585765c764cf11e6e53a9086041"
    sha256 cellar: :any,                 mojave:         "db4ba23b6c0a235b2478416040a2321e305fe2f57810e87d6b5400addc0c3eea"
    sha256 cellar: :any,                 high_sierra:    "5d53fe57d49e5c60b8ea81e633e502e73569e191f16fa36aabb39085ffe2581a"
    sha256 cellar: :any,                 sierra:         "0229a85f2bdaa14baabe840b12f50eed8eb88233d13bcdb0424c5ab6fc2a4a6c"
    sha256 cellar: :any,                 el_capitan:     "3b5927cdb5f69cdc57d8ecbdf5b6fc95a5b6aad7c626c79d1893f2d824030e65"
    sha256 cellar: :any,                 yosemite:       "bb40b6d09be26ee497aae27abea5808730af29e6387fa347996eae49c32c448d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1e73b80ebe89bd831b478daab8102fb6252f6d4bab39e11b67b46a05b02509"
  end

  on_macos do
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.deparallelize
    # Call autoreconf on macOS to fix -flat_namespace usage
    system "autoreconf", "-fvi" if OS.mac?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "src/tools/ta_regtest/.libs/ta_regtest"
  end

  test do
    system "#{bin}/ta_regtest"
  end
end
