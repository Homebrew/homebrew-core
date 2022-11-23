class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v1.3.0.tar.gz"
  sha256 "40f5472df5f6356a4d6f48862a19091bd4de3f802b3444891b3bc4b710fb35ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286acb35142223b6e0274221c5a2527f022c79f51a8f5d81ef5261f08b651b99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5fd3a08d92bfeb4da493930b49df96b38ad624f815b3c3f27a661f5e35274ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ca61de9c598eb8c2abd4b78874ff40af76cc83474ff1d2261979800a42d62f7"
    sha256 cellar: :any_skip_relocation, ventura:        "6805196d030a823a9e95dde8afd62ec87b21b6602f1cbcd7e40239638da40ceb"
    sha256 cellar: :any_skip_relocation, monterey:       "7e58ab275e612ff3d6072c1765d5a21fb151c904f56f3c238249be022c14e07a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d41ad7e32d8c75ca170b883b39cd3f5b34f800e9ea555d128a11b1a198f08c53"
    sha256 cellar: :any_skip_relocation, catalina:       "a1c1f827b9e04877c3c9082c2f531a512be07ff8f0afb204aeea3fba013f74d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac3f578746c21ef166d41389433354a0435093a8648e224ad55c648925f1764c"
  end

  uses_from_macos "expect" => :test

  def install
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=pbcopy"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn sh
      set timeout 1
      send "echo key=value | #{bin}/yank -d = | cat"
      send "\r"
      send "\016"
      send "\r"
      expect {
            "value" { send "exit\r"; exit 0 }
            timeout { send "exit\r"; exit 1 }
      }
    EOS
    system "expect", "-f", "test.exp"
  end
end
