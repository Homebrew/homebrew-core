class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/85/7e/2aa791c9ae7b8cd5024cd4122e92267f664ca954cea3def3211919fa3c1f/ty-0.0.32.tar.gz"
  sha256 "8743174c5f920f6700a4a0c9de140109189192ba16226884cd50095b43b8a45c"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9a8d0072eae9f947f56780847345ec0881d68bab2e06b5f0e7ef1949015de63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2751b0f008d80c240a286bdfcaa6fd28ac8e84832386d41ab8561a40a964cbdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a12adaf383fc66f0c5ee5b6b7a188ac35b58fc50054cf9fd614ac0ccdacca87"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d112f860acd6e6155d8e69f1f8b6cdf7187ea05e5c3be46d68bd5456dcb11b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "683b73e3dbdc3d8070ea4274b7b93ba1520f7913e28cf7126904e6f70fbac716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6fbca056a92492b6c1690e120f15fe19e63e26f043eec0db2cc30a7b2a96ac"
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
