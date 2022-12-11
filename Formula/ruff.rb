class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.174.tar.gz"
  sha256 "8dc84789545da8ea20ca18cebf113f2e134113f9328459e154ce99370760b177"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a6619929119f2c5426d8cc251238c0bef25ca03ccf157d616ef8b09463a9111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "580c7b4a086137f4ebe1dadb28c3d9b8877f0e22f6f60c5a5b36c4a919296ab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42f83181d8de6dcefa45775294b7a54ea5b5960bff44e78b5030246289a6b7f0"
    sha256 cellar: :any_skip_relocation, ventura:        "7137885466cdcdfc2c09c69ad8263979c1367f998eed3e8807873245003fee88"
    sha256 cellar: :any_skip_relocation, monterey:       "8046c843f3c866b55f5d0b85bee3d72967e9bc4ce677cb70407870fbb13e017f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd468d3a056181926a841537603a6da5c47be1949feaea8c7076148bd117e648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e68e75232a21541d38cef2d0a217499cf5140326be68970cb9fcfc822e01d2b1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
    generate_completions_from_executable(bin/"ruff", ".", shell_parameter_format: "--generate-shell-completion=")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
