class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/8a/06/fce7ef8edb9af069cbd17accbc81804e9638f70f4ebf674d0b7847a2023e/ty-0.0.103.tar.gz"
  sha256 "bf4dc5160a482d24b16e3b5057d638a02b06406d54faecb600a2c109cb023c45"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5dc8db16417130e9f6c242b7e7ee5064b49b33b2f9dd2f55af6fe6c9f16c0964"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10b607dc77939701bbb37fbcfe5ada8053315083bb7ea2de86896b29dce75159"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abf2facdfee42e8023ac372c13ed7b605468ef4cd56ad14ae6780c813dac6ec9"
    sha256 cellar: :any,                 arm64_linux:       "6e6c2bfcd285a8030808c0e345996f2124c8e76a660961a3016a3b11bb6cdff6"
    sha256 cellar: :any,                 x86_64_linux:      "8027d91e40245f521cfdf4727709f95b3f8ecdf6751840d09231eacaa6a438c0"
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
