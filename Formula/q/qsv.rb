class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/5.0.3.tar.gz"
  sha256 "3df998802030fd9a3e2cab12f2369ae75077ee74a7076c773298efbc30a4f61a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b101516623fba87ffe16e879d6b6aa0c0c327dee7d3150633c79e43464afd607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "561ed5fe0cc5b0259bbb66fa2b2380dac8d965751107da2a85ff7b8053f9e404"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f565a3366cc8e9e5e0e6a490b2e8154490b1265993f7f721c66f63103311f95"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf8c715c0373702bf144fb9894373d37be21fcc535e00e499f2ed76a5939c1fb"
    sha256 cellar: :any_skip_relocation, ventura:       "2f94499e561a9e6b94aa17b46995bdf3f408be508bf3087fb09721c65efb5984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46329a37301014303e1f2eb8fec47bdd86a0f57c99eaa29ecdcdcd81e1f01afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb21b32db5699f380fd4783e342cdfdfa4ebab21bc810ce79bc6a4d3202ec29"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    # Use explicit CPU target instead of "native" to avoid brittle behavior
    # see discussion at https://github.com/briansmith/ring/discussions/2528#discussioncomment-13196576
    ENV["RUSTFLAGS"] = "-C target-cpu=apple-m1" if OS.mac? && Hardware::CPU.arm?

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
