class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "7ed3ac185905dad49f7e042369070e9e4c98681334c940d15b5774125bf6a64a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6863cc6d3ff05e1803b438f841c4cf8be619571911f2c81939af1c4526ac5a09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6863cc6d3ff05e1803b438f841c4cf8be619571911f2c81939af1c4526ac5a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6863cc6d3ff05e1803b438f841c4cf8be619571911f2c81939af1c4526ac5a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "de09ebfaa1f43c99d398967abf460982b7ea9b9e437140e1d26cb40d4418de13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c22551f6173f90689f0069fbc5951e0f0b8d89312e5258c7de43b1dea83f9cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54476182719c2e80813478eba5dd13ab443a74f792b9922a730e5afeffb6b46e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
