class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/c4/69/e24eefe2c35c0fdbdec9b60e162727af669bb76d64d993d982eb67b24c38/ty-0.0.34.tar.gz"
  sha256 "a6efe66b0f13c03a65e6c72ec9abfe2792e2fd063c74fa67e2c4930e29d661be"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82d7288fbed54ac7b2727f8246263fcb600ebce7a2e4cd1eda8f0c5515681e06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfcaf72e7b668824964806e60e7325c62558ac32d02a72dd3b4fb9ef25d83116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb8d3daf75b35ea13e3dac75cbb8146191af209a02eebd941a0b4ca75938879a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ab53ea6f99bde87765539a404dd543b915afd822f9b8c86866f0a36eb6c3ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d586fb0e94813b8e73256356205f30a6252a0c9350a7d6cf6f6c9b49da42b639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dff9a9049cc7eabd47e31a6da7fc1a5343c3faff90edc8c1296dcfa3b1d90905"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    # Not using `time` since SOURCE_DATE_EPOCH is set to 2006
    ENV["TY_COMMIT_DATE"] = Time.now.utc.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
