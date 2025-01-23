class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/dathere/qsv"
  url "https://github.com/dathere/qsv/archive/refs/tags/2.1.0.tar.gz"
  sha256 "b512b1ed78809a004ba8900815190d351750ea86638d031ccb0bc4e7510afb3e"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/dathere/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b790e165fcb0939ac4a6d7790a5e923e69299e0a33d66a95aaf7328d025757f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1b3ad1a7fe8fe2bc07c10a725b66b8422d738021cc444490dc966c883b452f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "259e1164477593ec50eee0b0e8e19b59e1db094d1ce6b797eb5559267691100f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccedeaef5cd1c9263c12b2f2770656b2d11e2e614855090bdd22f5566e1905b8"
    sha256 cellar: :any_skip_relocation, ventura:       "04c8578b26829b303fd32b2311620ceaecd9f4e943d74c0357668e4153d76492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c5b0a7636bb2e1d9fe535ff0c288f06aeff8892979a72cb3ddb2de506b46eb1"
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
      field,type,is_ascii,sum,min,max,range,sort_order,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity,qsv__value
      first header,NULL,,,,,,,,,,,,,,,,,,,,,0,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,0,,,
      qsv__rowcount,,,,,,,,,,,,,,,,,,,,,,,,,0
      qsv__columncount,,,,,,,,,,,,,,,,,,,,,,,,,2
      qsv__filesize_bytes,,,,,,,,,,,,,,,,,,,,,,,,,26
      qsv__fingerprint_hash,,,,,,,,,,,,,,,,,,,,,,,,,b818de06455146a422a60ade18c7e4ee5872089c79c32fd8a87a0f05e79564ed
    EOS
  end
end
