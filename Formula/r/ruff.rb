class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f31d179ddc11297f33a509069f72efdc542350274d490c2be063287ef0290579"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5c686c4eedb38ad9ec36f60315aa0a8ea74d07510146a6d86479536ff5ccee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7242885f082025314bf448eb5dbd5ef01c5be1b2a61268f2d6d5e4a7a59d8422"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bfea00126a1cd4fea780999ea1cd161efac15e99501d35c7739e25184892e17"
    sha256 cellar: :any_skip_relocation, sonoma:         "6be230acd01f89802232c0ec649b2152a8aae99a421022733314679ed93795f3"
    sha256 cellar: :any_skip_relocation, ventura:        "795851f01430c38e9b9719917b3ec832e2706b5c1c11f69625d3d42d9ce7d00d"
    sha256 cellar: :any_skip_relocation, monterey:       "3d47e0fb5eab84d9fb0793cf578adda43eed600e66def1f5a4b4e57b4d504fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9da7619daeb9e7a9cf8618a21f706c6a77f1c5e0cc7097afcc4cdd982125cc24"
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

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
