class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.137.0.tar.gz"
  sha256 "46b29900bb439d11a61fbb2f856a47dc5653fa080c0d0282ad517ec7d1c39079"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fddf25b4c11c94d51bfc0dd6be8b30dd80500490e96c0f4dd9c85a0f32d4cbd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8fc55d0114116bc8fff43a606f770729dfea18fa8eed928ce9e641871966c9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6865d877597db1a934e3bcd9beb7bf120a545e3e084a734de8bc2b71fc98d479"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5ba25e250ab30eecb16c817edd7110eb53255c571ee0bf7e6e559f2043edf3b"
    sha256 cellar: :any_skip_relocation, ventura:       "eadc26e07093387e0af293c756bcb056d37b0aade9fa71af620d49fc514c1a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ab48a45f88bff2ed33ad7686338bae2cf9cebb71d24ffe26c65c648741eb2af"
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
