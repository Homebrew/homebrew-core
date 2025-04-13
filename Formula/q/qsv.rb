class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/3.3.0.tar.gz"
  sha256 "34cda085f10d79eb09145f57cf685aba798bfbb2131ce903d4925f270933382e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66718b010cfd806964e44940b6fbe9163cbe158b178e6b91943457a01379ebf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31974c4f8b76c8858b276aee3dc84258520be5afe35fa08c4a3f67a1748f0a05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "069548fb05d671e0dcb6f9c10de4d61f20c50d72d67d25601768817d0be2a0a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c625594d67497b5cc3f1cc383f0039732452a49caf723ec1ddf5ee63cf179500"
    sha256 cellar: :any_skip_relocation, ventura:       "7aa50860b5f33add996e9a0fdc0c43d26b7a03dbd263267083d8dcedeaf02b35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b603c3d8bcbb46e00489d139589a0caa81d16066f650ee1e891a27f361606ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a947e79df08863f8ce58576eed252c1b65ff6f5820a711afe9c700d2fc8d15"
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
