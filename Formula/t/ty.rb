class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/e1/21/096166a4d1118a6ce923223d53d14dc6262046604b6f1e667882db8d80b3/ty-0.0.107.tar.gz"
  sha256 "e792277547cd55f5e75208665da705825f0af627397aa7abb169d5ad994277ca"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f52b830fab047e4b03868faf7876fef391b546ae267632a0823b1794978aef2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9eb6ec22e6131a8582c35217a02a1ef6404e451b387d546174d958ea68da8196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89729394c4436db077d76cde95421811b6203d3a82754e039a59ece0cac82db0"
    sha256 cellar: :any,                 arm64_linux:       "6b7984c32e90e6b8c39910d7e7fd772ecbc0b77041a327dcd6e7b0a568540797"
    sha256 cellar: :any,                 x86_64_linux:      "650e5d3114025443799628bf16b6fc45daf33500aab936130fd07db0846a1c45"
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
