class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/a9/23/e7e960c518df4fe79c38154469f500ebc54631c1e8724a44c28ea052b7ef/ty-0.0.104.tar.gz"
  sha256 "8aa1330e722a5a56336d8d1938d8897cb5dfc0841fffd8ed0627fdea177a9bdb"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ba1e54895d458e993ba6f8106cebcf8c69023b5b4de6186dbcba259078ed6a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8b7aec442e6b4c526f11bea4684b5bbbf5532da3b78459a20fc9ce25807ec22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1146757661ed293501bc12a930813103bf17423e8367c33f388e9c99e659bec8"
    sha256 cellar: :any,                 arm64_linux:       "3e411d04a3307b7ca7fa030febe096e7466c268098fb8e17ee2de9cfb10ca415"
    sha256 cellar: :any,                 x86_64_linux:      "475a9c35abbeaca968039d69d7a0bb1293ec19aeb372abd0cd3f5b0f1c233e85"
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
