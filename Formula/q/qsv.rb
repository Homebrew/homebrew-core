class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/18.0.0.tar.gz"
  sha256 "20ed71f0303478d05a87cdfcf79f96793e77d8dc4321bd12a13d89c5040c6233"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "270d1a519c0f17c8eb628eac48f872dbbd4e2ba0dfa2280b7bd72f0e5f60d6e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c340a193f2c4e6f07c11428da076b0831cfdc122a2561cc7313644e3b50de2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b51b6236b1c3fcdacb6aec14d8d42361d485da4b1ae7767c5e09b90600b223b"
    sha256 cellar: :any_skip_relocation, sonoma:        "45ce2b4029406bf0f0670ecc6fd4da4cc8dad058052d7e41b1c70a5277292433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a164b5aa4af18b1ea3b9a01982e024aa112c5bf67de7ab7a62c873f9fcf2a60e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77b24245c948029f31f772fac51fa130a3add2bc3fc228c12387e9efc19f7cb"
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
    ENV.append_to_rustflags "-C target-cpu=apple-m1" if OS.mac? && Hardware::CPU.arm?

    features = %w[apply fetch foreach geocode lens luau to feature_capable]
    system "cargo", "install", *std_cargo_args(features:)

    bash_completion.install "contrib/completions/examples/qsv.bash" => "qsv"
    fish_completion.install "contrib/completions/examples/qsv.fish"
    zsh_completion.install "contrib/completions/examples/qsv.zsh" => "_qsv"
    pwsh_completion.install "contrib/completions/examples/qsv.ps1" => "qsv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,n_negative,n_zero,n_positive,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
    EOS
  end
end
