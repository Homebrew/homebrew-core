class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/2.25.1.tar.gz"
  sha256 "4df3c1c55a391961e5f33c4775296f420c0e348e9f74b285ce739d9da791e5f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d35517b79f5d360d8b5907e155086fd76c4f4a080102415d2baa4ae923b3b883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ead121802f8c45597ed2e04d4278fa411cad33f65f5d46b8518bd957715979d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22f229ddc3ee09e2b2868072957c2edbc344a2d2c4a1f1387d75356ca908edfb"
    sha256 cellar: :any_skip_relocation, ventura:        "ed55c290f74f15c7a47374b456b980c9317eb163aee5e36a678156835b89716e"
    sha256 cellar: :any_skip_relocation, monterey:       "b23f00b33049060d6213a59ae1e11287b717bc1f94603244849dcf09a7325f65"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c5bfd7dbee095fb183ed959cdc5c43667d39e47ebc727cce3ab8354ede3ceda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2260085630805dab109289db0122224f1c0e820a78b37abd2a1805d90234584d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
