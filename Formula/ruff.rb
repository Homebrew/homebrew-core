class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.199.tar.gz"
  sha256 "afacead52692f219e658dcfa393ce54476bf2d0dc400d45157c665a63b9d89b3"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0552c7e7feb9b985b216f3d970c0c0f5198c0b1f5887dfb0331a94299e3d4f62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fb9a708d2357ebadb7bcdd95409e484895984ee97dafb4b9674eca00241831a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36c91ab962e3c50677b32aa8f0d348bb281c52e4fc341a6281d91475a86ddbdf"
    sha256 cellar: :any_skip_relocation, ventura:        "3eefcb00bd1c42d92a27f678bcd976ca795463c691418e49b696c2ddf59014c3"
    sha256 cellar: :any_skip_relocation, monterey:       "28d71afa6b2c480216ebd1404ac8d9b1ca036c7f45a648eb01c5d48df1d863e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "39edb544fa51c704f983e00615f3414949e993f4f36b1e1669ee5fe2439c0fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb051c78e0ba47ee64ec39091c0f9b283c94afa7a4eff75930c7cbb600956231"
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
