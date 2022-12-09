class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.171.tar.gz"
  sha256 "f9243a74e5311d06201bf0ca24a036076951705e39e44187a50f89e11c402ac8"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86f09703872751a47d9c57c976d247e39b58aafc0547ac093d63fe95fe7e9d66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ab5e7d8f90291bb7b0346467df0f093d3e662786b4e6d1d11f6f11609e3ccb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "494b2502d397199da224ebd8889d3e7188369f50c03a23298a6c292c02dd637d"
    sha256 cellar: :any_skip_relocation, ventura:        "46533a072591dc77e28b6c93c8d8189ac1df1a01ae51c57774f44fe53b723894"
    sha256 cellar: :any_skip_relocation, monterey:       "67a71c230f7c6238f7e2d3fcd14d652845ab9e8f703231548b63896adbdec32c"
    sha256 cellar: :any_skip_relocation, big_sur:        "676d79e8240690d7f108bcb26d15cdaa9889d88847e41754bb8c17b33833c0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f6e7df76d4679af94544ccbf84557e0d07d00fefa01b9814a9ce42e074b9a55"
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
