class Xsv < Formula
  desc "Fast CSV toolkit written in Rust"
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.13.0.tar.gz"
  sha256 "2b75309b764c9f2f3fdc1dd31eeea5a74498f7da21ae757b3ffd6fd537ec5345"
  head "https://github.com/BurntSushi/xsv.git"

  bottle do
    sha256 "e55868cc4f9f6284ef7aecdff580dcc93699a8ceb03beb7ed27d29ad9ee23707" => :mojave
    sha256 "9837a63d7a48c82a723294a24e66e64920c0b0ead2bc92c408e502d76cd482c7" => :high_sierra
    sha256 "c909a6c8c825a231d0148fd3776d764bf6c0a67663f2944e6b66ae492b206387" => :sierra
    sha256 "34848a92e9e392a942e31cb8af2c725e80742c27ecd6f0579a7242015b50259a" => :el_capitan
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
