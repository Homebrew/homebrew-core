class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/55/07/fb29aea5235b0aa8ecfc4d1cc6ddf9fba8b863d67d96c6d345694d644c43/ty-0.0.56.tar.gz"
  sha256 "84d114dc3796361c0fc72945016eabd74d46b9ee64f198cb0e485719704681e5"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0047fa6b6ccf765494f2e2b3d15274b97ab8b6658a993c0291c226dd5fcb622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e8cdf6018d3737854f12d03016e7fa9c4378551884face3c4bac8fb6baea4ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ae6f282d6121cf6e09313f73f6abf0eff3b225ec64aa95e1736985743e4fe85"
    sha256 cellar: :any_skip_relocation, sonoma:        "c106865ec0127d472db6e10157e0d7354efd3961e9db275640613c5c9ac60607"
    sha256 cellar: :any,                 arm64_linux:   "920522529d8bc7bcadee277df7dc5178896eb9cc6e6f31d15eb1fc34f7c8d5e6"
    sha256 cellar: :any,                 x86_64_linux:  "b6a6487d72211b80fb146db30b03d2ed228cf89e5bfdf7e8b10376b19e7b8c3a"
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
