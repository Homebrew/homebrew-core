class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https://github.com/dalance/svlint"
  url "https://github.com/dalance/svlint/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "716accda481e1da015af5059348e3a5c6487d82e1e85cbcd5f6457f002cdbe37"
  license "MIT"
  head "https://github.com/dalance/svlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8c0b4f390801c48cfd5f6004581fa5da07886f74a922612d1d975048e4c2f1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ff52d80372bb928e3470885fdd62c3a686dbb6dab726d8564b068a9aac8844c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1286dcbe8892fdbe5d3ce9ccdd11beb6451b8adc6e8a979801592d868c83681e"
    sha256 cellar: :any_skip_relocation, ventura:        "1dad384d05891c91a289b3c0bba23d4db45a8a6c8c69809a01f67937ef849b83"
    sha256 cellar: :any_skip_relocation, monterey:       "e2c0f4853b5104200d12eb7d2c24a9f08abda62441adbd0ec6d79c291ed008af"
    sha256 cellar: :any_skip_relocation, big_sur:        "2016168fcf958c0963d21f33294fcf858691a9b1a880fe14e147fc3067cd2ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155e57a9faa08b576f4199c43934059db0cac0ac04fbcb97cf1c9330d5e92265"
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
