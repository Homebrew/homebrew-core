class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/34/6c/22c0680e71f529e084ee2e308a51f04317298248ee699f4914c02129c351/ty-0.0.101.tar.gz"
  sha256 "dbb43374b49fe30ea49e244da63aa90098dff1257a49ae4351b44881ccef724f"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a18679d8869e3d190aede79550fcb8e381f19e1f4e4599b44ff6e36f63f7539"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dcd8606e25774b2ee0d1003b3ec60bc5eca0ee9087cbfd5ab445c7f98c683b9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a4e11d1f4091f42ff31ce8e294bb0aa74828b3e21da02ef1307cf543955ed69"
    sha256 cellar: :any,                 arm64_linux:       "8f6273a2fc8f176415cad8edbc26263949f3bbefb732af1060bea8ce6c3a6b90"
    sha256 cellar: :any,                 x86_64_linux:      "b3549f8d157e59f7494ce2e385108d8003c664fa101a435c9a8b6f55716330e4"
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
