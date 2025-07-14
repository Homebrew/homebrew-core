class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/6.0.1.tar.gz"
  sha256 "d4a4dafad7cec344a927e92a1d42b4da210ea83061b9de8094da9d06f0d1427f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b19ac97495e9159af081ecdae9bf9cb22dfaede6621f27c8ce750e742a36475a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f9953df792838a7b825257cee6f77c61b047ae704a4b168c1aa512d9f2d6064"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b2dbb689d8da8297dcff27c6ce7602c0505ebb95d08a5b81d7f2a021a8fbc90"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdede4883030e9a399a634a4247cce3a5210bdd1e8c38b9f7919d7dbabff77c7"
    sha256 cellar: :any_skip_relocation, ventura:       "758d3cb4253ec497007f9023e13aad4ba00df910c5eea99285f1e25c9c389f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69d5fdd79814150df5d04943a34ca82aa4261e251e0c9fa8d8e128f95a80eb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89cc4719724f478534fec9c1571f69acdb93615bfe458db681947e934f8c8c6a"
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

    system "cargo", "install", *std_cargo_args, "--features", "apply,lens,luau,feature_capable"
    bash_completion.install "contrib/completions/examples/qsv.bash" => "qsv"
    fish_completion.install "contrib/completions/examples/qsv.fish"
    zsh_completion.install "contrib/completions/examples/qsv.zsh" => "_qsv"
    pwsh_completion.install "contrib/completions/examples/qsv.ps1" => "qsv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,
    EOS
  end
end
