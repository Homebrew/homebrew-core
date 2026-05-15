class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/4e/53/440e7b1212c4b0abbd4adb7aed93f4971aa1f8dca386ac5515930afa9172/ty-0.0.35.tar.gz"
  sha256 "8375c240ab38138a19db07996c9808fb7a92047c1492e1ce587c2ef5112ad3a9"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f88198a367f4515022807818f7edfbaf1c0ed12a881894124696fb1ff189c2bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5513ebce6d2206bd4f4fa80f9d533d98397cd67a4f7fae7fdf4cb690f54f7a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ce9b8f2006b26f785d5778c5ab133d68b0da2f600ce95f7a36972eb41ef3567"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff17a5eca29b384dbf686442ec518d216b49c29aacfe8c688651687fd8b79888"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aebdda62b64563edf75263fe921738cdb67647510df47e4b17f319b494cbca64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65854c6d7a1d191af547718fc108e8fd1825369a538a3a597b56ca7dd1284930"
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
