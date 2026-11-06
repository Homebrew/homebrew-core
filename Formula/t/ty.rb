class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/a9/bc/a17167c26defcb6ce004b3668624deb47ed98955f5ef14d8aee6d533d6c8/ty-0.0.98.tar.gz"
  sha256 "91778c8201da22ba553fb51c5b01c346b7ab37bbf0267536c86e5be4f09467ad"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1bb00fd3993ebec9dee0e28bd9e03e743d568cf47e6d3641edaf5659d8d11065"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab82f1cded871844efbf7c36249b0134f50e8a4f484a4df664ddd920e63afec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d3353658b75b77d04ccd2170491c47fa0cd0ca50030a9f6c67beddc80f2cd1d"
    sha256 cellar: :any,                 arm64_linux:       "c3a93e170aed2bb0ae9121df36e5a157bf8ba7cb827760a55b7f3bf62f1c221d"
    sha256 cellar: :any,                 x86_64_linux:      "f472b21e6eecfadef15dbfb174e0fbcba2e1c2d97fae6b8b06fc0fdadedcb764"
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
