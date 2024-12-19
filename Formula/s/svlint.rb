class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https://github.com/dalance/svlint"
  url "https://github.com/dalance/svlint/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "ed07d77dd72fe49c086df407ed74e321d210eb19dc0dc353ebcf23414116ccfd"
  license "MIT"
  head "https://github.com/dalance/svlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8e0f4520274a9d65fa8c5355950064f9bf7ba4545e1e4fa59d2dc78f98dbceb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0650e00432f1b1bea694d145e8d82793ac8c2803b6584c77626bc6ff9734bb09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a597239fb738c494719baf5ebc71c4be2b8f28fa94b6397fd49d0170c0f17f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d28d81b6d76eb7678bb61783f4d31ec4f54d4ddf609da3ce097175e571a6f46"
    sha256 cellar: :any_skip_relocation, sonoma:         "74700743529098809fc76ece0a43f1c19e8a5e1e653c88444cb7c62e38b222fe"
    sha256 cellar: :any_skip_relocation, ventura:        "999f7136b567446b81d26b4d309f696af0d6da7e0d29f5cd1ea7ad78b68b2741"
    sha256 cellar: :any_skip_relocation, monterey:       "b84d5719b75ba93a3514ac17ad1438d27a096e3d0fb257384ffab3d1f126ec4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dcb14a7dae2848d3bccd8f938c3deffd4270cab99e1dff9bf35fa5873d226b8"
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
