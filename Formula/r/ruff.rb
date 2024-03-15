class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "0065193961b1398dfdb43cc196a67f7275cc97a711b994430b62905144116e19"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9614b1ce8c18fa7efa331c61cfa9c7f0416a0627513e24037059bb9d16605af9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "316416ae88240c542188ddf7533b7ae2900b6b277d6d163f4b8bcb1e5e0f7586"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "369fe1cd22c7b0fce9fd235adb554b29db0f2d0bade21400c02c6aeacc899a6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8951f7cf82ddaec5331cea134aa16a0918ef17719a6f62fd836c50070440413b"
    sha256 cellar: :any_skip_relocation, ventura:        "2e7c722022baef6d7c576a961238e69213d122f25efc1f7d53d8dc642af35d72"
    sha256 cellar: :any_skip_relocation, monterey:       "067f2e89cc19267fa54b270d548c2bfb584ab882a5a23fc405635a03be31beaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17044e3c7e9fa6a0dffe29fd20a3394c132424d7c135fbbaee26c4a22c4ca415"
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
