class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/dathere/qsv"
  url "https://github.com/dathere/qsv/archive/refs/tags/2.2.1.tar.gz"
  sha256 "3ada256641d4a56e82cd9d3e48f62188eb6d8dd80b96385ac72c302d729504a4"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/dathere/qsv.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a58f287033c1a73c0ae90a72d564109a2e59d848a17fc48348e12eae36f847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cad0df4512177bd581822b3bbf7438517fb085d8471795ae2138d8873737662"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee5501186db0ca2a558a406c653821b86e9bcc93911f68f2032aefbb29225004"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeaac5da5b9a491e5773a075dcff134c429a67579936b5d5d35d64323ed219b6"
    sha256 cellar: :any_skip_relocation, ventura:       "ef852130a655f3598489fc9f81224d626c971483d73254019ff25395579bb7e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae46300ed7267bfb3fa6621212e93806ea8a0f5f484e1d273be5caaae0abe1f2"
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
