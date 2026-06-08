class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/13/f4/fbb120226e4f239652525a664bad976a23fea58c646d1323f2296fee8a61/ty-0.0.44.tar.gz"
  sha256 "5886229830ab77022842a1c55d2ef57405621a91fc465969fa6d538661898173"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d31fc755617f1e63ad47368e2158512d9120c6fb12265a27a5d463638318e46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2072abae4e0277cdb89a7c8d1d6915d04ecc9af28150f0d701531d4f348732b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60bd71bd0d0ae42df6487e784212299768c6bd690e97ae09ffbd1367d65d3c41"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d707c6731dae12b49482aad80bd817660a03b8e21d2df8dab85b1e53aaef39"
    sha256 cellar: :any,                 arm64_linux:   "2cc1071660e9e3f4dabf45305caf412bbbac01bcd49941584a851f4df7e47ffa"
    sha256 cellar: :any,                 x86_64_linux:  "e5435636b8ae57ca7b0e401961c79d0e030b8ab22e4cbfb68b78d8c3b427f991"
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
