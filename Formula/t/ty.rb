class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d0/95/25b7533185c74ba38d859e3477e74cd98546f59a4ae5cd3962d11c3c6bdb/ty-0.0.96.tar.gz"
  sha256 "f3026ef87a5ee1bd0687100c775af75a53289afe8e35b6e85bc3d1ce7d2f98cb"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d4be00aef17f496c75dd3f7d75386b4dada7c90fd36f36cf87a541a3af62a77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15b17c9d6426104b4a74cf4b95734d9fb1a3ca1decce58724826e19d02a6bd8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c7ffa1a4fc152f723aa0f2c83a5f510a9f3360ec96281543cbb9c76e2ff26068"
    sha256 cellar: :any,                 arm64_linux:       "e994aed4e246602be0e436ace7832f82b473d54c9a23bb92b1c8ecd5d13172c7"
    sha256 cellar: :any,                 x86_64_linux:      "d4106d82a1b1afb4f51e34652e58fa173972c51420667848d883933d8bd4579f"
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
