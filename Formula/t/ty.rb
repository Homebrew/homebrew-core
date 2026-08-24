class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/88/0f/c767853e88567a2ec7e996dd95e3105b1bc62c95d103689311ef0f4a603c/ty-0.0.74.tar.gz"
  sha256 "da14344fc8625fc9ff359bafb856ad575636ea86d9bb6a629b146bff27b380e6"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fd105507fa51e4e98a3dcae0b12fdbe629afc651c31ecc0387be0eac3b508f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a58be479c714a01df6cf128cb9202591bfa5dc587275ab6985bc6eec84375ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3201fb2cd19dad1d47715d29740871b147e7fcdfdba6705240a74ce0bede9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "55964ab235bce2ce11585fa6bcdf20c196dc394d8efa8e07d9eca294d190a425"
    sha256 cellar: :any,                 arm64_linux:   "bcfb223ac52a9a93334bd372dea672936a55810c8161930c718e097290f15bc8"
    sha256 cellar: :any,                 x86_64_linux:  "31a64f60ebf6749ada5f86519b18c281fcf98d24a364c6462eac6e6c2b1fe581"
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
