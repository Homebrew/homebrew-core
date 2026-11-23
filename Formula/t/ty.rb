class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/25/e3/2d5ad8406ba1f8e7e404a70bf19bfd1af68f6548b03d2b48243acef5a4ab/ty-0.0.108.tar.gz"
  sha256 "890f214ca1e2f3b14da23d0f519132d466ba09fdb820677df73ae208a6683784"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    manifest_sha256 "37ab32a28d9b2ee35e392b798c1aba4fa7e94647201c1117b5d88bc3b81e8ac6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd532a64ad696ecc1b8029928c749cd7a9e404f9fdbfcd0610c8696960f3c178"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "713218e956b84bb3cd5434ea5f105193093675138c291bb87ecec7bd06974d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e7c0ff5df76a0d526819323d7b6d682fa67ea474b28e70cb448584717dfd852"
    sha256 cellar: :any,                 arm64_linux:       "a23e1ba26bff0733460be73a53137e9ff492460d12f9cf4951a8e196d6f55f1b"
    sha256 cellar: :any,                 x86_64_linux:      "1d8153f910eb2a3f049fcefd1588b4488ef0a45682d40c892118087009738649"
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
