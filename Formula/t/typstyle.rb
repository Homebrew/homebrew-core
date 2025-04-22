class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "4414d32dd104ca39e41aee67024440f0483d7b19fe36db0fa2ad7fde31dd86f0"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908526301d9ccff36f4b9feb05fa8c64d0cf8e7e26d7b9712bdbb9b74b1cbe00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4e6d3e7c63c63c4c15ca2b8d2e7a554f0a09f6655c8319a36a241acd2be7fe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22514e02556b10267158735b80a36aec0f04d9b9b1bc874aadddde67c85a77f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d82d1da4bff2093dabc315cbbf4741e13276e625b284183c4062c6cf1b7c90cf"
    sha256 cellar: :any_skip_relocation, ventura:       "5e09aaf41e4df7bfdee787af192b748782f7162d25c2f683c65f802fa09ecf9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aaee3696dbca94ce2e5aed225bf1318640c4b03b6d370518a3d35347e9d6f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ae5879efe75470721ff8509d0d6468857b8eec9112280cd7020e2dbbfe8dc6c"
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
