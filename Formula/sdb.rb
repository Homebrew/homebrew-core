class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://github.com/radare/sdb"
  url "https://github.com/radareorg/sdb/archive/1.8.0.tar.gz"
  sha256 "4040dd4457f266e9566d2a19db7ba76c80b789b218960815edaa3be479261123"
  license "MIT"
  head "https://github.com/radare/sdb.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b0a860ce797a943bba94c3cd5f2b26629a79ffa7c924b01f0a1361130f90a7d6"
    sha256 cellar: :any, big_sur:       "5e21c95c80e644bb031539b6d485f2dcd0d98d2f048c750ad912f78ade9b3fa7"
    sha256 cellar: :any, catalina:      "97abc888fd762445486fa5c635fadba3423d5249332f2fb9b4f8183227375b6e"
    sha256 cellar: :any, mojave:        "5f96b1c74c0b16f6171c0eb5d132b7ff08e8c80e71b2db080bedd681ef5875ad"
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
