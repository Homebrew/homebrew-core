class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/ff/2c/ecf9d6a7456e64ea9114d21e68edaea77ecda9151cc89dfd3ed0b673e4a9/ty-0.0.62.tar.gz"
  sha256 "145b6feba4d5f38b6d595eb41f7a8ec1c970a0a83b79a70680e9e3b787a3e381"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6adfefd1b86c32375125bd9340a1e2b62cd93228a510138bc0ed68b6bd70d8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487f6de85fc71d1a929b7ce5a142f8cce230c1bd8b929503c6fd83371d3798e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01393c374148599341aefedb7cba5464a237431a646610393ad7c61ea46eb65a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d39c41b1881d58f210e73493a47b5b5731930b239617c1c1e5ef1bbbe80d6ec"
    sha256 cellar: :any,                 arm64_linux:   "7749982380f687349e80502fd90dbd11c9f1025caf42b871128df45ab0932d88"
    sha256 cellar: :any,                 x86_64_linux:  "75a76e629fdd82754f645de6e27ce7e698a525f73089790c6b2f3ffd89f22479"
  end

  depends_on "rust" => :build

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
