class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/ae/c6/2ea90406d82cf82b0a68725130da2cc9de161bfa883c7dee4f0d94dbf3ce/ty-0.0.54.tar.gz"
  sha256 "b6b3cfe174f27744413c898b2488ca52ea76070637095de131698e506b455055"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61e8b3d00028877fbf34eec60fb753ca4652e7c5533f0a237703ab987175ed75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25cad8592a790eee6c30b99e7d18f95db3ee11fdd6ede0779ac203291f1bd6ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "522951ceb74ced1d34c39c07490c6fe122ddd432041e97e2cb8c120fd163392b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0e5b47f08da25bac0558b3184696d84deec952e78f918169cfd7bd3238b4fd1"
    sha256 cellar: :any,                 arm64_linux:   "e7fa9a4bb810652fc58cd3245560983eca29338c83d4bdf0fcfbbb46a44730cc"
    sha256 cellar: :any,                 x86_64_linux:  "1ae5fae4870e54868722be7d49f3edd1a02ef8168568fd4eb90c388b85f27c09"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
