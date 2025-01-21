class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https://github.com/dalance/svlint"
  url "https://github.com/dalance/svlint/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "ed07d77dd72fe49c086df407ed74e321d210eb19dc0dc353ebcf23414116ccfd"
  license "MIT"
  head "https://github.com/dalance/svlint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c82113e0273481d396f4d0b09bcb50abe5034c9397c9b4779e235df99dba9cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d4983f8a4e157a8cddd6e4e3aef2ad28dc6b1a0048134e1e8894f6a8259ceae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e92e737e77aa193fa30e67f5c443fec1329ec01ced2ec0cf74ded12c8037f614"
    sha256 cellar: :any_skip_relocation, sonoma:        "a54509a5ccbaa642caf7f72f8d24aa93191b4ee8d7eb5eb42f5c9c5c302a552e"
    sha256 cellar: :any_skip_relocation, ventura:       "fcc94fcfab52c8b6fca8bc7473bc59f14748ee9a97679b344a9d2d724456d063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbe93914caa4cc7c788375ba72a0dc2d1a1bccde48f0100a1f39b2fc70ae8827"
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
