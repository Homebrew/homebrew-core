class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https://github.com/dalance/svlint"
  url "https://github.com/dalance/svlint/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "ce7a3686f4f4ad4a1a24f9107f1622bdca63aca17b1fd9b2869f58ae8820e886"
  license "MIT"
  head "https://github.com/dalance/svlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2af311529fb86404a4d0a5b23f9505c0dc30c664e38b12acd8b563af7af5e646"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11da3082805a986aef5ffe32c6b07a9920da64fc0930c3f60f9e94d9624857dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9444d1011c268fbcc21c834d556b6ba266d37664d14a75580ac12066d76f2e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "91329decac58548cc43aa35016e30a20fc2e64c93209c5effe573883bd84f8ae"
    sha256 cellar: :any_skip_relocation, ventura:        "285130beff04e82b3641420e7d1b3ef9e0374d1b246690eba109525a5a720b85"
    sha256 cellar: :any_skip_relocation, monterey:       "604038e6f9ce4c1c176dad4a3045d29f99c34faa7f069764f8f4691587660927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47f05a3e8e2102d37e9e4830dfa3ad79a5562d6a910104b873bfcb7c873b4d34"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.sv").write <<~EOS
      module M;
      endmodule
    EOS

    assert_match(/hint\s+:\s+Begin `module` name with lowerCamelCase./, shell_output("#{bin}/svlint test.sv", 1))
  end
end
