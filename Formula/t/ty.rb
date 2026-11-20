class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/e1/21/096166a4d1118a6ce923223d53d14dc6262046604b6f1e667882db8d80b3/ty-0.0.107.tar.gz"
  sha256 "e792277547cd55f5e75208665da705825f0af627397aa7abb169d5ad994277ca"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50f4bef50ac13c8aebfaaae9cfc5e8a7a11fc527c83a8202a6250a43514415b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "353c3e288c547ee80603360eabe2ddb1cf34c94297b457b0f662d149a93fb883"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ecc0db09a115541ff52d90a582c248e40a7a062943ecb224f972b79d22b1eef"
    sha256 cellar: :any,                 arm64_linux:       "e052b4ca1a5a895aed395ecf6751f84cf53c8ce6b159d3419b0611e8ff1e060d"
    sha256 cellar: :any,                 x86_64_linux:      "677147eaa16927b94053990b71d8c9e4dc9f0289d1ebe34fe1d685b0d9349d7a"
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
