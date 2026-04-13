class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/47/d5/853561de49fae38c519e905b2d8da9c531219608f1fccc47a0fc2c896980/ty-0.0.29.tar.gz"
  sha256 "e7936cca2f691eeda631876c92809688dbbab68687c3473f526cd83b6a9228d8"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7b7799c4ef5a339bfefad01de32c1bcb1ebe8674c3306a8fc6dc3d6b33718ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa86c920cc2b30dd4b131158de67ea3fdb1350f7b1a1b28d430ea7df77481b04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a81f72122ac8c7008afeb0e266ad9e0c48c223d9d1de70d1a0841fe8b5268b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "02bc4d65cc98527cd3ee8284048a257ff93fb04f3986c63f393c3b343c5160eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0570fcb2fcb323cb137b12842c327391a250fa686934eaad0188ad6afbcb851b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9ced9c8a5241f19002becff1a4115e89b62eefea5eb1ff98d6b7a333e87ae5"
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
