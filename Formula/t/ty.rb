class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/a3/e6/433297132750c18fc661b7bac6ee69daad7103ed33e74cecfa96ff90d148/ty-0.0.106.tar.gz"
  sha256 "70eee20bc3b22ceb3ce8f1abfe811088c1e102aa96160b9a543954710eda7008"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdb7b7e9828b12c05eb542413a6dfaf933d5679aa336ec05a9e9616a374d344a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2a037c9afb7a134370ffdf17c2dba54106089155c49e7c235102a1c8e881177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a28218f6a6eb4ce6998bfad81baafca1e487fbf0f32a3dacc4227093292efeeb"
    sha256 cellar: :any,                 arm64_linux:       "610e8c962b309dee3b3e2f6bbd488804631510aa98613096cb1f6c24a4de77f6"
    sha256 cellar: :any,                 x86_64_linux:      "080f3fcd4ede8c3bd1f379bf739e0598edee2e0757d13159fb48549ba0604586"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The sdist prunes some `ruff` workspace members but ships the full repo
    # Cargo.lock, so `cargo fetch --locked` would refuse to shrink it.
    system "cargo", "fetch", "--target", "host-tuple", "--manifest-path", "ruff/Cargo.toml"
  end

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

    shell_output("#{bin}/ty check #{testpath} 2>&1", 1)

    (testpath/"good.py").write <<~PYTHON
      def f(x: int) -> str:
          return str(x)
    PYTHON
    system bin/"ty", "check", testpath/"good.py"
  end
end
