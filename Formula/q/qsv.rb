class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/4.0.0.tar.gz"
  sha256 "87f53ba8099142e8a1159d600ef6b9e4329bf10a579f38257d757c99a45b33a7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b97e11c4747b55adb66c5b14c8ab88150147c1ec557810209f460e692c2f505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a98e6ff18be9eb72fe838bbb53b7eef18a72efe202b2366407c60a8f3c0e1cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "942132a892c830bb3c5152539c8ecd61dcf85240ce51b39c2b477730c16c5e70"
    sha256 cellar: :any_skip_relocation, sonoma:        "02387ab3ac368ebbe1634eef6a3d54641a9f450db56731c83a1acdeeb7bea9ce"
    sha256 cellar: :any_skip_relocation, ventura:       "43103014ac89d695da2d064af7cd1e8647a68c517cba655df6b16e8ac2fe6028"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "954a045ccb42de014bd0daee2daa477236f9f380d093eb3254fb1d90ac1831a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b4996fdfb7deec5da50ea5b51b3235506d3c53690b1ef37745c701f982a3e1"
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
