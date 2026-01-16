class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https://github.com/dalance/svlint"
  url "https://github.com/dalance/svlint/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "1ffa212d571eabf57fb2b32c648760a0aff301dff8282a5a2b8e653d4657d3fe"
  license "MIT"
  head "https://github.com/dalance/svlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c7f5d699c98ce1810f10f1341ddb6be404ef7bbb78f1691e54b1b30ca7ab11d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f304dfea7f9fa13a5ad184799901d98b97fb3d63e0fcb29f47b493c472c8ab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45535bbe0f59b90e30295c90ab9501417562413e8142fc5db1c04c79945e318c"
    sha256 cellar: :any_skip_relocation, sonoma:        "60542d776cd14eacbda668e5071821fd3afb3f46307c58fad1b3fb5e174bed0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb5f9fe1851248d81df1f8a116a6091cf818265bd85d80978f7a3a99f3fbe623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6335fa6a65a382040f5c71d8a377c97f65a0637771d955282303bbda39da9ea8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # installation produces two binaries, `mdgen` and `svlint`, however, `mdgen` is for dev pipeline
    # see https://github.com/dalance/svlint/blob/729159751f330c4c3f7adaa25b826f809f0e5f44/README.md?plain=1#L26
    rm bin/"mdgen"

    generate_completions_from_executable(bin/"svlint", "--shell-completion")
  end

  test do
    (testpath/"test.sv").write <<~EOS
      module M;
      endmodule
    EOS

    assert_match(/hint\s+:\s+Begin `module` name with lowerCamelCase./, shell_output("#{bin}/svlint test.sv", 1))
  end
end
