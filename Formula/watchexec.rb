class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.14.1.tar.gz"
  sha256 "23ca90f1f070b0d30e821667c8b9deaf174d020373ea032e9e22f1a78adcfa1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d4e987c12e2ccdd9ed5ec73c7c987259faf2687195c5d3be4e8896b67c372f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "d53e7eccb32fcefde96e0237d8a900a64fcda304d94b9a675528c75dd0cc419a"
    sha256 cellar: :any_skip_relocation, catalina:      "bd5816dbe23399183808f0a407a4d605d7113644c0e8fcf815439fefaf734dfb"
    sha256 cellar: :any_skip_relocation, mojave:        "c8ba045ce6c7d45bbd5b3c12dc4a17038b1ca1d1ffbd2a1742d13c8a971e15bd"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2add0c1e367f4626d16ded8470adbc3e1780811259d0b2faf52e8d0aaf50f91e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 1
    touch "test"
    sleep 1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
