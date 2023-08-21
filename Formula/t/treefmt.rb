class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://github.com/numtide/treefmt"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2ba130f4920b45409efb7d939c21d9a9d4640d46f76a5ede13e2bb01725670c8"
  license "MIT"

  head "https://github.com/numtide/treefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6b4e5ac0a0a14309bc2c23a6eda313753e7369e27a428516dea578ba3ded552"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95bbad56e99d607acea2e60867c7b91799acc581dba563c0b2ab5da700c009e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f3dd5443560d3a461fc920ed071fb3ab9819addde82d17ab97afbf83d7f07c"
    sha256 cellar: :any_skip_relocation, ventura:        "41d17fe258ad94a2aa57130b76a1fb56912165620f1a543a68ffa76d98d52b24"
    sha256 cellar: :any_skip_relocation, monterey:       "3894d15b1fa3a022aab9c6fe436b90100c9f6b51acb6ef44f8cc7a39647319c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f76733299331b9f3b0e065a5d5b4bbb4e4ba436ee4b38d8f5873d40fa0186155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f416a903eb4fda7f650970bd58074efa1688b1e6467dbb61d31c687c91f0a90"
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
