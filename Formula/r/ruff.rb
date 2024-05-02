class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "7f08b9b79afdf75eb5528986f0ac8a7fe0183d5b1917cba7d7d595b09cb58d6a"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3ca6994532456cede59b21ec7ce70ac2a0e418bff7eab82257aaf259a883b3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ab15cc890c560b8ad65db56d42b5e39b323a3c6e070014c9b5901e58a0f1851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a39db5213e55fe35db3fadb5749aa082a2ade465ccb9896ee4e5cba5849f7d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "63f70ce492a79719154dc43e7c539c677ee28f5370af28519f886db99fd095de"
    sha256 cellar: :any_skip_relocation, ventura:        "11215756255e894b095895c7aec821cfdff4066da686e26f4a364e7530b52ed4"
    sha256 cellar: :any_skip_relocation, monterey:       "7cf14e099836403f4a0558cb3937aeb7b8f797b6bde139fc0b3aed2edf4b2772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da2c3b7994b288cf061694f2388264524be6f222c97e657c41d7323e64d0993b"
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
