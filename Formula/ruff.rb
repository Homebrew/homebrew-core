class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  # ruff should only be updated every 5 releases on multiples of 5
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.225.tar.gz"
  sha256 "54728209e313aaebc9283fef86bdb29cfc7ad76da4168cdb16499b334624ae57"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04848f426282927b1435355089d687718a6a6271f6c3e15b231678cac3429c65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9b92f0a6b1ae52ddf6ab3474201e4feb46da816980fb7d140eab7fba2165407"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94a1548b925ee7380ba51035782b40d9c875025f373aa46dd519ab3fdebca3d9"
    sha256 cellar: :any_skip_relocation, ventura:        "3f1c55c1ce1b02611764fab291e7608aa8971e54a00ef6da53ec9d8d03202dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "1e1b5e8523ca10c34c51fccc9a4f8c92f613ac8bc8c8e161625181cac0ca3347"
    sha256 cellar: :any_skip_relocation, big_sur:        "789d5943c38760ade6f4006b3246e7ec353a5ad339564ed2b379b2825d0ebb18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e058f384022b09225771c2ef3c670929f3d80fe48e419737d8cc04068e6d651e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "ruff_cli")
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
