class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/2a/b4/ac430b910566e28b1cd01faf7ee07ca38bcd7585b30fce8fd25dfc104edc/ty-0.0.100.tar.gz"
  sha256 "ca75081ead663c077e40b90c38b6e9f039b6d168051e02918a8a1d7ecc4fa0dd"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d737a600c19b68b68ace0131bab56050c5553b07b7c48af8521151a0f229fe8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fee58b4f80e73f312a478a3f8ea1815578cf4998423665c9977e24769a52807"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "473c201269194fc329e36f8cede5fc53b43f2403436adae873b82946c6d08db9"
    sha256 cellar: :any,                 arm64_linux:       "5d650d43dc08773a3d186207c562933b4eef96aa54c62f5521a1808c1f7e0311"
    sha256 cellar: :any,                 x86_64_linux:      "4cc27c33939b96802877b54bfb5ee2fe42fb28a9880a0ccb4217118df90f7338"
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
