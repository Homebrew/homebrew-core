class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/a9/bc/a17167c26defcb6ce004b3668624deb47ed98955f5ef14d8aee6d533d6c8/ty-0.0.98.tar.gz"
  sha256 "91778c8201da22ba553fb51c5b01c346b7ab37bbf0267536c86e5be4f09467ad"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "738f9628504fc88338b7bfa86b0b4154bd04d84987f47acfe10c78b4c7e1573b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c8840558c6cdfe289f1b10dc09ef78854dc2ad6c7a374281b64bab508b97c0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2fc150d24c55e5cb95011f8610d0e4f130357a055e79cfe76c56cead74c6c9be"
    sha256 cellar: :any,                 arm64_linux:       "c2a5dce3e077f1204110ea7884acb9b3f992f33034071158e88f07a62866463e"
    sha256 cellar: :any,                 x86_64_linux:      "b0fbeee1cb989f0d70694383690d9318f7bc629449dab858427d444e1df3edfa"
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

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
