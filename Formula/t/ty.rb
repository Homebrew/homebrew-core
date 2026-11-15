class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/a9/23/e7e960c518df4fe79c38154469f500ebc54631c1e8724a44c28ea052b7ef/ty-0.0.104.tar.gz"
  sha256 "8aa1330e722a5a56336d8d1938d8897cb5dfc0841fffd8ed0627fdea177a9bdb"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "137ed9b354db90f0eb34e2ff50c0e725d6dbbb3ae279436746d2a5277f50e873"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5924ff2d0ced8a12027af07aa03b1f5c2ebc7d238ab3df2133cc49d863480bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05619b7e5e5ba818f9e289e064b978a2888c233d38418202d5c42963d5feef19"
    sha256 cellar: :any,                 arm64_linux:       "977b7c453788d9b04878b375816b6622bfb0429ae437072903708891bf1e9b94"
    sha256 cellar: :any,                 x86_64_linux:      "b2eb7d0a6b97656ef77b60393d675ce2bc449a8bdd53abaca479720ea4c8e667"
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
