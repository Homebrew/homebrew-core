class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/b5/78/ba1a4ad403c748fbba8be63b7e774a90e80b67192f6443d624c64fe4aaab/ty-0.0.12.tar.gz"
  sha256 "cd01810e106c3b652a01b8f784dd21741de9fdc47bd595d02c122a7d5cefeee7"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24e13efe833741e884554319beff5ab8b97e9c75d05c2f5da179f5802c5ae1a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f75f6ab6c6989637e60a44fde79c2795714c12a37923e24398b5f7fe5a39c44a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1831e2b9a0124ffde152e892c8c507cf73621a22d8b9dc9d0f79763c9f1edd48"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca89fba0a5fb9e584501f377b4febab78e5d846544a2b17be2c937f29c1d710c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aa55146ac7be63df8afe043847993216d98f5385a2970a4a93a7903b2f43a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb5fb98ec12ba5366e30f76ba54112c07c31c4a03e1a073a88bcf8f74bf48279"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    # Not using `time` since SOURCE_DATE_EPOCH is set to 2006
    ENV["TY_COMMIT_DATE"] = Time.now.utc.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
