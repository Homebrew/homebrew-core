class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.169.tar.gz"
  sha256 "d35fb24e9fff017ad254d19351f8f8b01cf6142e4510f52f5b2497e2bd5fa8b7"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b14113ec63354e3b23e6f4c02f114756914be0ffa249c593e25c974f8496ebfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2355de2973e8f47a9d4d80a4435780dc27233d84fe3fedc6081e8cae32f8bc6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbc3e589d553ce9c493da0516cdfe83156063db2729b3b7e9ba8cf4244cdb207"
    sha256 cellar: :any_skip_relocation, ventura:        "1bc735066d59cb7795b1b2cc28c9d8b16e6baf8c6e66a1f91a8bbf05a36cab11"
    sha256 cellar: :any_skip_relocation, monterey:       "a1421563b776dc2a5df650145435048b78b2648d0627379f6081de69d382b026"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d065e56694915154703c37f77d09d00ba54a9fa2e478634911bcf9559bf62fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "586e9942284fb4d188d9b93c90338e2e0145c6d4ba47685fd6fb8de8a9f6e45f"
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
