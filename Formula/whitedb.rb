class Whitedb < Formula
  desc "Lightweight in-memory NoSQL database library"
  homepage "https://www.whitedb.org/"
  url "https://www.whitedb.org/whitedb-0.7.3.tar.gz"
  sha256 "10c4ccd754ed2d53dbdef9ec16c88c732aa73d923fc0ee114e7e3a78a812849d"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any, catalina:    "9ec140c350c8233dcbd67def0607eb1cdb764fd3f14ac57ac3901eeeda554e0f"
    sha256 cellar: :any, mojave:      "05673924ef2226616618002bcbcee6241db8f1ce34339ff38785fd4fe82cda43"
    sha256 cellar: :any, high_sierra: "3dc724386650bbbf608c4742d954c338e1927427e4c4f1a9c0d6255cc8deee5d"
    sha256 cellar: :any, sierra:      "44639bc83668def2e81b68318dbdb5347f9262937ddb6cfdfd7303aae1ce05a6"
    sha256 cellar: :any, el_capitan:  "c0f4e666e9cc755bbff0711a1494c9705928a34a565701147bae31793f505163"
    sha256 cellar: :any, yosemite:    "0fa38dca524c08f51fa724fb49df5a3ebdde46a3251b2a282d5343b36c4c249f"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    # https://github.com/priitj/whitedb/issues/15
    ENV.append "CFLAGS", "-std=gnu89"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wgdb", "create", "512k"
    system "#{bin}/wgdb", "add", "42"
    system "#{bin}/wgdb", "select", "1"
    system "#{bin}/wgdb", "free"
  end
end
