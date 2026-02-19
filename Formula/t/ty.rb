class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/66/c3/41ae6346443eedb65b96761abfab890a48ce2aa5a8a27af69c5c5d99064d/ty-0.0.17.tar.gz"
  sha256 "847ed6c120913e280bf9b54d8eaa7a1049708acb8824ad234e71498e8ad09f97"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fcd66ccc8846119682595543ff4c7cb5bb8e96ba2948c969c0ff9e3304bbae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dd01b60eaa9a063fde28983d3360059b6a8228673d48e10984ca53c168e0143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9baef811c7caae5d161ba881e2449d12f2d2bfdbbfb4a5482dd15dbdfc2384c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e665a0c430624a3a693464e7e90373d486357c954653b1b1caf5906373100f5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607dfbb0a7f23118b45cf3996c62aec1a3a7a7b6690b34eaf42e3456fa68d261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05438f37ddd3f3eb2d46840ba32440012bda9711edc5bae966e53d458a2c43f8"
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
