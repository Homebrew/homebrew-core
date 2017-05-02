class Xsv < Formula
  desc "Fast CSV toolkit written in Rust."
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.10.3.tar.gz"
  sha256 "856addb2067724319b85c76619a41745e90ba0bf3d42221594154479dc4419b1"
  head "https://github.com/BurntSushi/xsv.git"

  bottle do
    sha256 "1ab64eed1a4df158622cf1cb346d979762da4c8fbe2ffd3a50bfca7201c3e7cc" => :sierra
    sha256 "4609a9c185a2f946d1f4a1814005dc83a417de58a1b0a9e8e35e25d4f4813910" => :el_capitan
    sha256 "b5e72b6f1a1586d7209efc0c38464d3bd794c092c5cf5ba2fa95d51f45bd439a" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"

    bin.install "target/release/xsv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system "#{bin}/xsv", "stats", "test.csv"
  end
end
