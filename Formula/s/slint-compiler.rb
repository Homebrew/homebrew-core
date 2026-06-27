class SlintCompiler < Formula
  desc "Compiler for the Slint UI markup language"
  homepage "https://slint.dev/"
  url "https://github.com/slint-ui/slint/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "1cce5cc1e32a140e35366fe819fcf17a7b278338f67073d7bc97d4fa7a2a4d4e"
  license "GPL-3.0-only"
  head "https://github.com/slint-ui/slint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de5bf8c987e697f953e00212978468e1b9cb514c38a74cfcf0df4850b6578e9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c66de9b05bfe64a048edb0877a5a78c0c200be522671912fdab4de74f837ecac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12c78e0b98cd515b51a0bfbf7027f65da38f343d8595c51b49702936d3600c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fd881a1c6b81e15e45ac9326870bcff12f16f9cd74e56751986918f454a9500"
    sha256 cellar: :any,                 arm64_linux:   "2e3d208f6c63141af5c9196cad98c7e277cbb396a999aef1df85667b416cfe24"
    sha256 cellar: :any,                 x86_64_linux:  "3f74ce9c082c3106cd086b797337ea5db137228a3864c8f7bc653d916e7efed3"
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
