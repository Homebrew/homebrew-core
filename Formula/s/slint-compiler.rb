class SlintCompiler < Formula
  desc "Compiler for the Slint UI markup language"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "fe485305ed303215e76c04918ee9aefbffbe229f18f979098ec36c7fa1dab28b"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "040c51eb6d29db5a1cf5fafde6f44072c8c29fa22a25c52b9cd6c62f3285c3fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f98596ec4af400644a38c9ee6084d5f27ef6864d2cb01be8111f4984dad1d7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17639e5997286763f74457f558da05ee317f7992cbddbc8dd6db0c087b132b91"
    sha256 cellar: :any,                 arm64_linux:       "0fcf52208be337ad96768e1e15c411b5053e45ccabd67662e7fecdaf2a4bfd03"
    sha256 cellar: :any,                 x86_64_linux:      "d3d2b0a8efb415ba073b0ec8aa91b0279279e8f85eef012f84d8399410ac4cbf"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
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
