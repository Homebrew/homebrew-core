class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.9.4.tar.gz"
  sha256 "5d0a40ed9359b174e6b5420aae908a1120dbc631a62160916fd8dfff7a799e34"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "906406070ec1cb8608e72f00712f6be2564e2b8e741d3e808696979a687a119a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46f25417b80a2517578f42b254d381980a289e30498cb2f51e9386e3c6b299d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "569775ae99520666fd7f7a6b3e33859328037eeb010fff6e71ed40a50d9fa78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d587c10c16787633e41e7626862b39897889b67ac9a8ca07157427514d915d93"
    sha256 cellar: :any_skip_relocation, ventura:       "c66dbe32d9bc4ca10461eae0524af23fed6ab45a170fb4b84b23b3ff226a6317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a898e71e6086645d8cc56932ed4e621e8051b3c69df21e3abb04c43cceb736"
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
