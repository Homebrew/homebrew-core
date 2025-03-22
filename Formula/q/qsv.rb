class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/3.2.0.tar.gz"
  sha256 "43e425522083c57de1ee7060463d476b20ba9db05f4237791cb5fceda0c77aa5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08a9789a26767aff0eddbbbc1e5959b988c6423ceb441bea47c8fea406f35c96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bcb144429c5448638e732119031fa3891f509bd5b0bf03bcc8051af4cf17354"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d061eed8f7397b998761e8ea48b4d8160670d17cb3d70816fbb4367c421d928a"
    sha256 cellar: :any_skip_relocation, sonoma:        "69814dd1f813db2e3436efbdba6d30541786380c05f637b07f9fc8825c99cc16"
    sha256 cellar: :any_skip_relocation, ventura:       "c0033b85cb6fe46f4dd8d31b4643ef167f8b5c2eaf388f63c2b28d0f64026b26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0d9386f532bb5cab8bf435c8459b223377457dcbe3b19f1ec4fdf501fca0287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "def1984705310d4fda05529e058d81daa5a17b7716933901306ec50df43a8cab"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
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
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats --dataset-stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity,qsv__value
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,
      qsv__rowcount,,,,,,,,,,,,,,,,,,,,,,,,,,0
      qsv__columncount,,,,,,,,,,,,,,,,,,,,,,,,,,2
      qsv__filesize_bytes,,,,,,,,,,,,,,,,,,,,,,,,,,26
      qsv__fingerprint_hash,,,,,,,,,,,,,,,,,,,,,,,,,,589aa48c29e0a4abf207a0ff266da0903608c1281478acd75457c8f8ccea455a
    EOS
  end
end
