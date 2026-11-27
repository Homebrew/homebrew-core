class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d8/94/e6c3f8ed304bc5d7ae66ae5cced39b5c48151527b5bc69693e169918b9c0/ty-0.0.112.tar.gz"
  sha256 "8e7eb8c95fa08b35f7e86eccacaf2be5e1fe34a7c7da164280d292e1180d5907"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    manifest_sha256 "71079bf81016f760d587242f919e550fa386d28c522d780479a7bb7decb843af"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3dfcba1ec692679dfa92960e0354dceb0bb21a96ff38065827f657dfe8d698a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0456b54bb9379e15dce10a6c70f18000b3860d62005ac3eab27b6aa798f50551"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8037d2520fe7592f7b133270e4e5010b941d99a24a4681a5efa3e79a3d318a0b"
    sha256 cellar: :any,                 arm64_linux:       "027bdb820498e40ef889c77bc9ab38b7c882cf19e8b00f35c77714a08b14139e"
    sha256 cellar: :any,                 x86_64_linux:      "ec85ccd6a30a229ddaa76051944326a9d3bf8b0ef9f926a3deed46e3e6a74567"
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
