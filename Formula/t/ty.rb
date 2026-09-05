class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d8/c7/2ba0861384c5b5097ac354383abb98188112cb330208c21d5197e98a29e5/ty-0.0.78.tar.gz"
  sha256 "770b45854f85fa11595208f08c0f28df80943164d10a2832d86be6ac29f135b2"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be549311cfe38bc4a6b455c3e0aa552a503e6d3541e754a7b13df7f152a8c6c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc645ee6e0c717b0d1834d76d82071304781cbaf3bb6b92f2c729a53e7f2f4f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8206b28344acc6964041c18c2946cdd1857738bebd9cc75b41214bbe6ca2841a"
    sha256 cellar: :any,                 arm64_linux:   "b486137e3b86199896f6812e2ee5f777bfb9e88edf3035b133df7d49319f3d90"
    sha256 cellar: :any,                 x86_64_linux:  "9c2c1f34356084aea468fc9c88067c703baba1ada571b22760146f36535db1bf"
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
