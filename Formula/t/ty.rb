class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/7a/96/652a425030f95dc2c9548d9019e52502e17079e1daeefbc4036f1c0905b4/ty-0.0.24.tar.gz"
  sha256 "9fe42f6b98207bdaef51f71487d6d087f2cb02555ee3939884d779b2b3cc8bfc"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d78d717e82aee3a2d3b3b01e1941528d6ceefb523c37ef413f45a8950e2107a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "642bf47469a1a8270b4b4e9c4856f566a1644ad40dca1c0ff55c2d308db2412f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e397dcbbe57c6f69a13ec278937677d1903778c42b28527d8030db940c07d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f250c855ee6e8cb041bb659a14babf50f477068229655c50e450a0452da87fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20d0537e6e873a031259e44938a06d64ae9537365a8d9ab6e1c235b8b6efbf2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49475039e9387fd5d2485e4aaed39a822b7438bf59a02ba2ca53ca401e34e59e"
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
