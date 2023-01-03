class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.209.tar.gz"
  sha256 "853d7d50e9abdcaecd1471e217e02a8c1170e5fe9baccef1ecd8f99dc022f3cd"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "167abac42fc51dec950788aff92b56e3860afd221ad91ea35583b473166fb5b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "333ab953768f0a5bb4cd5fec89ddacdf639592d734f52c1c29672cc197c7612e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6518c9fffc2c2d842e2a32350b72765f70738be4c439d294180f722e3550336c"
    sha256 cellar: :any_skip_relocation, ventura:        "01d6975de131fa67e52cf74a90506438773f9c33ba5c6181ae0d5887c9e68408"
    sha256 cellar: :any_skip_relocation, monterey:       "dd80423509aa53468a3bbc382e432b1990d0178af4fde0bea9703b9490aca204"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9857063c1bbf2342ccef23249486902333d7ed4157a01474669333d655b043e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a25c9b6f8b1480550b63b9ae29f8bdd4a2f048043bd8f85acec7ecbf0e9a2ec"
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
