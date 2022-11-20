class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://github.com/numtide/treefmt"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "48554e1b030781c49c98c5882369a92e475d76fee0d5ce2d2f79966826447086"
  license "MIT"

  head "https://github.com/numtide/treefmt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "848af1802dbd4b2e155842f0d4d88f6c93890ee9e8b7913a17df9891a1884b8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70693c71f8e8d0d6dd747c5bb42effce35701cd1dc48654a53c293e07d0fb093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "070f05b40ef90f9cca25281b022cf06e32214cb4bfe8ebed446521c4c7cc0122"
    sha256 cellar: :any_skip_relocation, monterey:       "083823b01f2d0241b4f64f1b48e887d5a8e6fd6fec3f4403ec83ae5e2eef9173"
    sha256 cellar: :any_skip_relocation, big_sur:        "75d9369e6f359a4beb25c2f7eaede113aaf5e8e9c8698d85f2ff3339af02b1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e635602de192435ca5dd8f7c744520d16ff10eaacabd92f536e9f10ee7a81eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that treefmt responds as expected when run without treefmt.toml config
    assert_match "treefmt.toml could not be found", shell_output("#{bin}/treefmt 2>&1", 1)
  end
end
