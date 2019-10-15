class Xsv < Formula
  desc "Fast CSV toolkit written in Rust"
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.13.0.tar.gz"
  sha256 "2b75309b764c9f2f3fdc1dd31eeea5a74498f7da21ae757b3ffd6fd537ec5345"
  head "https://github.com/BurntSushi/xsv.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8d155cc9c61f185849bfa30c52e697ed8544132a39c0f883be6073a7d8b07b12" => :catalina
    sha256 "d343b54fc05a8bf5fa01c7a0408e742bc145465a414466a6bcb5efb62252eb62" => :mojave
    sha256 "e38f68fb0141d59deaa25230ab201e05df63fc5d03ec1afdf2443c61943c4a2c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system "#{bin}/xsv", "stats", "test.csv"
  end
end
