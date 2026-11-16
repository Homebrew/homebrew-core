class SlintCompiler < Formula
  desc "Compiler for the Slint UI markup language"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "9c15a9f6dfe94fbe96cb97dcb38207907403a67c9b23d8a93468ea1bb132246c"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc8ceff7bbf6846062280fea3bb4efc80f64c000172582d975171f4850833db8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79739ab1c5d988778475a3a7def00f8562f64e0f33d8ba8370648ac94ac704da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "960f7af8e554b6bde42baab24a16d58a2c667cddff3686de7742306a0d26f4bc"
    sha256 cellar: :any,                 arm64_linux:       "aca66c211284bd1a062f5d2f8abcc0139546add42a7d725301cf58f4792b87de"
    sha256 cellar: :any,                 x86_64_linux:      "e417e2c3153dc2720928fcb5a3c7aa0f683753eab0ed9e37225718839820d123"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tools/compiler")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slint-compiler --version")

    (testpath/"test.slint").write <<~SLINT
      export component Test inherits Window {
        Text { text: "Hello, world"; }
      }
    SLINT

    system bin/"slint-compiler", "--format", "rust", "-o", testpath/"test.rs", testpath/"test.slint"
    assert_path_exists testpath/"test.rs"
  end
end
