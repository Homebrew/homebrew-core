class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/cf/57/d0cabbc33e6e04c0406b9771ef3a05b13f34c3c22e69c3696ab5431dc28b/ty-0.0.97.tar.gz"
  sha256 "5346478c114ca9aece58b4df94e41cc17f373177f0795d15db8e95a8d1edae0f"
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
