class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/2.1.1.tar.gz"
  sha256 "8ec776016adfa3c02c99bbdcb021f9a80dfa1725e645d4b0f4f33d091531e98e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46ac1a79cdc2d63683d6b99faa613823cf70de0d6bd3f5274dee4e7d6b1612d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "81ba6ad8ced1af17b7cc50c53666a1789fd45ac522c700bed8ce74b60ce156da"
    sha256 cellar: :any_skip_relocation, catalina:      "25c95255b2c535a584697d87a14a1e8c70930d78f21cb056e2697bf79232f400"
    sha256 cellar: :any_skip_relocation, mojave:        "d4b7738f0b5cc63bfcbca2594bbd1514843f290649aea95880b223f71ba7ab9d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output_v = shell_output("#{bin}/tssh -v")
    assert_match "version #{version}", output_v
    output_e = shell_output("#{bin}/tssh -e")
    assert_match "TSSH_HOME", output_e
  end
end
