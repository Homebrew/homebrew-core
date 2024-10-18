class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.7.0.tar.gz"
  sha256 "1bb27c8b7da3d2d2a676c677692f9a527d5fa5697a52c0515f9662f735449293"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2293a7a91801873802a1a41c6c67b9032e4268384e92c8d1dfb2de258bc05728"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "235204564ca38b3ee3bc8b5a366abc91a20dcbeb42a6262529148d3aa312a6e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d25e9ecd575e6c4b86a99d3cd32ea3b80e1208bb796a9a290e176ac772f9841"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27637b87fdafe9238b3f47dc0e2f3b2184f38d66f53fbb3ac7f6f12d2959ff7"
    sha256 cellar: :any_skip_relocation, ventura:       "8ae5b2301b935302dc48f71d985ab7642d0c47af07e8cc5c6abb599a3ce88dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4f1f71046f8e49489ab23b28975c4a2474c0ccb5abe3fb63563a6e7fc1f355"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
