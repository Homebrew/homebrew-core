class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/07/df/d914a453dfe6c92c6ce4fb3c5507f0ba71aabea1d437708e109642f8c75a/ty-0.0.110.tar.gz"
  sha256 "0339d980a2ac78f356737260817ed9d11304a7a091fef57e9bcece1f00779742"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    manifest_sha256 "694e6d4e94f449ab66b3e7e84b3a1305d5032d01fdd646e4227e40709fe70889"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9baa35974a143763eeda1eed01612dda6e1f543a6a08a969cfe28a20bcf7851"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "898f1614e032267f4f742ff653c47195eecc9d94f2762d89c39637943577d791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e09f20d18105f6722e8125a85e3febb33c1770b593f24ef8d9ae81cd0c656579"
    sha256 cellar: :any,                 arm64_linux:       "c157ef77d4d8eaa89ec2b67267b0fe6c11e0dac3519303fd2febb3a79cb40f3b"
    sha256 cellar: :any,                 x86_64_linux:      "05b03d3e998db781e72122c622949742590a3d93aac253da0a51d251cb5a4085"
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
