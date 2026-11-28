class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d8/94/e6c3f8ed304bc5d7ae66ae5cced39b5c48151527b5bc69693e169918b9c0/ty-0.0.112.tar.gz"
  sha256 "8e7eb8c95fa08b35f7e86eccacaf2be5e1fe34a7c7da164280d292e1180d5907"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    manifest_sha256 "657ec31866c0a45d7c5c1a0afe665f04bd0b1c3ae1f0cb0f161f041110edabed"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7a1e5a2cde7f00c8bf2067e780d34e3a68e06998adba19eb743dcd4dfd03801"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7945cb24059b405570a7db654f29f138e1e89f1e2330f460b173cae7d93a4328"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1952d6e67202673f5078537fd85497ba2514de74838f7e9c0e40ef542ab8bb6"
    sha256 cellar: :any,                 arm64_linux:       "9874a7ce143de5b658778b182edaa95ea346c1d17799a856b20a33ed05f54441"
    sha256 cellar: :any,                 x86_64_linux:      "03e7d89125bece446f727df20761d93081ee1100cf3a180634a933268b105539"
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
