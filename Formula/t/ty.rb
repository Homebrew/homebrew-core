class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/3a/cd/6a98a3aaaff380637dd7f0c38e065d8857dd2f9cd871fca7385e5002a8f5/ty-0.0.99.tar.gz"
  sha256 "6a08d4f220e750a8c14c897c39145c5aeff385df456f837b233c35897ff5ea2e"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e73cfb418faaa07b481aec2ec42bd9f292d87fe2111fb839870abe6ef1cbaff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe935267568c4a0f08c5effc52688afeca90b58b6422624e422d938a88f2e664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ecbee926689bec14375f9d7d72a00fcad0a88fd9404ef183d5244d6d3218b7a"
    sha256 cellar: :any,                 arm64_linux:       "8a0acb433801bbf6b94a3be6b28c782f2fe9eea945896c5277b0d15204b29199"
    sha256 cellar: :any,                 x86_64_linux:      "9c99f28712700426a08478d9f4d76a7007d08b2a18d87ce026c9ea85850257a9"
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
