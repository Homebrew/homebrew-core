class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.16.4.tar.gz"
  sha256 "8e26878a97a0c7f2b364bac11b585b793b8913b14b850c0922d27d4d06de5173"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cff7690a268916bbe459ef05c7d4f776c0608694d226d181e086e9ea7ff30d77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6477c045d41abe1ba33b3d3b0ff08e6dac0088d987286ec2e98523044c034bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d26d7793ca54c41c726f93d3b2fa8480c1232449af0198ec3b4e1fd63c42bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "40ee8371f595615a1ad33b22e98569bcdcdf47d027691d34c414cf17aada6e53"
    sha256 cellar: :any,                 arm64_linux:   "d12117d11445def19ce175a26f7dfc91b2b61ea7c3867dd34cb8f502a0d8b717"
    sha256 cellar: :any,                 x86_64_linux:  "d46ec6418f6cdce18fb478a16233c0fb012b7d3eb1ceb291284d00f28e9e6f36"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
