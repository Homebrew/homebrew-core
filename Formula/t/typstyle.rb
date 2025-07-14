class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.13.14.tar.gz"
  sha256 "83a1169858a0c9537220e7147740f6b4f3480e7737006e144613c2eb16e3de2e"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dce8b384aa42ad795a52e7ab1163c83d8c3d7bdd47f21c41e19e2f2e31d0ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1520e1469814ee499cb4f8d2335ca6058b5bbdd189b71ef033e04d3e5ec4419f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baed6c3464b04f3d602d8aaf207a77510d1830db983513785c266b1126bb72e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "40008a0b6d71fe731751bcc8b6b2340733bbad1896c3c5b7eaa60dc04db3e00d"
    sha256 cellar: :any_skip_relocation, ventura:       "2ad43ce5817fd0a358fa4d6112040676f1103a0bc013330a279961d44bf42c06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5559dede5c47fb083d4e5fcb9daa8f035f1e5c16a18573183474d5b239014491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d26d0db9a4bfe719f79bceb0e49407ce9e1a6ae1e70cb2a01f3d2a2a94a3e67"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typstyle")

    generate_completions_from_executable(bin/"typstyle", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
