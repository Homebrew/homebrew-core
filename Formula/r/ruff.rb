class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.10.tar.gz"
  sha256 "42f72c865e0484f490cce86441df2207f38f8da6334013c859c5840f0e69c395"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57e362e88c71c474f4fa58d4b52190f6624de6bbf45cbda0071d3029db621f24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c78743bdd266c36ddc9a9b67036101302e5af555160c98fc96d7af42301c225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61aca546724d975858584acecbce852e511744844f6f2dbad835f4913e95e7b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "010c0212b2beb52d567def81c6620ab16d63f4b8d7c2e6fb54687b768d7684e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8776455883ae227f28f6319db5270a1f0a387953a2dc20a236df336be569ae66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beb41e58db25125b7049d60e6d80dc30fed6b6265ffc2aea921a3c514d9d8ff7"
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
