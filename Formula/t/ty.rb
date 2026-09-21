class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f6/df/b9f35d0b8860f1bbfcb852fbef363301b5ca4b5590cadc6f2a810646d579/ty-0.0.82.tar.gz"
  sha256 "586e3bf784cece42113929bb64b4761bed5c2127ae6cea294bb82da670066356"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "091b904ab53457c6275e41b72a8bb45e963cc4568940d0c7aead4f12c2fa9ebb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0852f0af878c7dcbc0df0a7a88c8b67c9ec3654e5ae7eae612b508f3d5d05892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db9be1151fa2acd7d6c8a7ed0caf0b8fa3b9e24b031c4302d10747b24fe6ef8b"
    sha256 cellar: :any,                 arm64_linux:       "2f8a867fd06cab726f326ca593bb0802d94340af096e32ec36180ebfc7400fd9"
    sha256 cellar: :any,                 x86_64_linux:      "73fa8fec665df6d765bc3ca836b7898e4066a9f1e78ed1ef6bdccc5aeb1b965b"
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
