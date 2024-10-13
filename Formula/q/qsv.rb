class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.136.0.tar.gz"
  sha256 "12149c7d84a3f1a28a65bb6e82a5d87b3f2f886e1142be90233e1507158f94a0"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60d56abdf8f4e8f2a7ec12d848aaf01754f17a401dd50e403275cbf20d1faaba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2048215e3a795558b3ea8c164990b1e7cbbfdd7dcb28b16bd256024f8f88c2e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e1db731c78b3f828bc1812f1f59fdb3b1f519ef72a7f33c342994aeef0c15ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8a0b7171f5e6308b3b4aaa5fb07ec9174e1ee6f074296bb435fa8479bdf2bfa"
    sha256 cellar: :any_skip_relocation, ventura:       "ea01cb419ed8127ae0c7f577555d06fc240739bb8d7397b142dec2c89146c8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c64c80f1489938d081fd381a87336576dd8ca380f2afb176f1d5a9f77304618"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
    bash_completion.install "contrib/completions/examples/qsv.bash" => "qsv"
    fish_completion.install "contrib/completions/examples/qsv.fish"
    zsh_completion.install "contrib/completions/examples/qsv.zsh" => "_qsv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,min_length,max_length,sum_length,avg_length,mean,sem,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,,,,0,,
    EOS
  end
end
