class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.64.0.tar.gz"
  sha256 "677ae23ffd247d43b11be588db4e7c3de423ac100425806210cd7fa43deab3eb"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b760074a0f6cff6a4181f6dbdadbf28d76b1285bae2ccedaf7426b8aa4e05999"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b480f185a727679307ebd29df4578c8ab996dce2a06720872d14510fc77895cb"
    sha256 cellar: :any_skip_relocation, monterey:       "5782b9349db83d902564acf11ce2ed1c4c98f76ecd348c810e54ee8ea5dc919a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbea8dcce3ac0e960d8c7877ef644f05d69c8f6228b6b1c48f16f0e8d2cc6c62"
    sha256 cellar: :any_skip_relocation, catalina:       "10af2679d8eeef496aadb9e50202fd81d2cb3fd9b105c6135fbffdc85c020937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "427a50078777f0dd675a00db9356a16c49c1f3b01e8cad1ac3279c7548a37017"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,min_length,max_length,mean,stddev,variance,nullcount
      first header,NULL,,,,,,,,,0
      second header,NULL,,,,,,,,,0
    EOS
  end
end
