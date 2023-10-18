class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b6f1467505acc99dcec7d67ff9dbcd00c63a39f338e09705a90a90205c8553d4"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab0204c6c3184825bbc31fa951e2a344fd334b14fa7d9a038a37e041e2f0adc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf86c510513648d23bf43d643f591910d1d3e0d999cdf26232c914762c705a25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc237790890acf29a9e4a64d45292c5c62f9a6c33a4af9bf478cee8016cb003"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9aa8cffe800b8dc0bd5f903e2d60ea618ae166689c128971b2f1f32d415c241"
    sha256 cellar: :any_skip_relocation, ventura:        "a7bffa1ba6ce000d4c5f84651e1d62dd7397348faff9121029dc3fe7942ef53f"
    sha256 cellar: :any_skip_relocation, monterey:       "653b97a085af5672b094af80d193657b36f49b0f4e71cf8cdfffafa4c3c7ec35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f769f39cc2caa465dda9dcddf42bacf63560045f14b6d6f59512e7522cc0b8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
