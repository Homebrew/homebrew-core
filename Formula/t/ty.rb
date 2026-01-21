class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/5a/dc/b607f00916f5a7c52860b84a66dc17bc6988e8445e96b1d6e175a3837397/ty-0.0.13.tar.gz"
  sha256 "7a1d135a400ca076407ea30012d1f75419634160ed3b9cad96607bf2956b23b3"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e12dc2f476a1ea8ed3c122e35c481263b592cb2a81f306e4ba7337a60089517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "663405252f6dedd8f3c154e6d68de78ebf8d83d53b80d2a57350db46f4e9c3cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "461dfd1e92153104223e11a150b8e446a65a01a6bc9d7e6b56641e7850c985dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7a88178d01e9e4e31b29da82abb4423b46e04ae45a78cf4ff5dbf86eec237db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d79011a13bae8dd1d011a52c4cdfeeecffc62f6beb06a644ec9f89e258bbb1d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfd30071a718bca572b9e2e937a66e21bacb816a823ce9ae4d5618c767ae4fad"
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
