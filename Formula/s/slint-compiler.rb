class SlintCompiler < Formula
  desc "Compiler for the Slint UI markup language"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "68222567f8c70ff677cd4a98cd94fb4765ac0f797eb8f8608a646911c908dc2a"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afd63a837ea6f0e7fcf0ce7ff03e1b097e5bdbac2b8b5b1e41dd647850f63ae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "371503c0334cfc487fc9b5b84c527ca69ef606e6a556a6ad4526c679802ea367"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8f41b00edc47778e0c9d6db52c9936c799767ab3b3283ddd56db288da0bdd15"
    sha256 cellar: :any_skip_relocation, sonoma:        "c459f5ba08d010d970189d9a73be84b59b62856789cf1905bd0edb8c8ea25ff5"
    sha256 cellar: :any,                 arm64_linux:   "2d5715db959e9a4e1c88d0c4f46d96650c3295119294eae274e5a9901f95129a"
    sha256 cellar: :any,                 x86_64_linux:  "bd2fead8dd3d72cb647253028a660e73df67ff6df7783deb01004355e0f23373"
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
