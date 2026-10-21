class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/67/ea/dfb9bdbc168c50a568809466596751afa0c7da60da03b8c12906d1decde4/ty-0.0.89.tar.gz"
  sha256 "bc1027b1ea95cca25c2a3a0b41433c809cf4b86a384d2b2434eba4bcd34548d4"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "baea15b97c39c721a74bc0edd4fecc910703971681521a93913910feeac84a2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13408513e482a249f190380e7b5f335e9cd2d395fcadf19448497c884a135031"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03d40d65e2e39031833fbc322b17d20a08a194a2893a2a3e2f11833b43a45261"
    sha256 cellar: :any,                 arm64_linux:       "d512e6cf978d6b9c70e20216ded07a4a18609fcff4bb321a3330b34e29336dc6"
    sha256 cellar: :any,                 x86_64_linux:      "9748c8f297643fea92a25b7186966abb442c9c43c318c792c0dcbfed9df21ddb"
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
