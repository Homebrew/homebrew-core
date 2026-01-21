class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/14.0.0.tar.gz"
  sha256 "b03c3aeb5e6106c2c0a1aa15dd2bec04c493c3347166edbebe39dc7006a3791c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79c47a0e065da93ae8ad17e406df303f393fb6519fc85bf9af4ca90b54fce907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f3e8cb3ae9a4d9469c0fc898e612b8972e9c5e7cdded4d95d312e46cb74e519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b11731276b0df30f37f1722f3f0953dc62864f7acc83f4398281686aade87f85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a60e61fece1a36618f62e86f3bf8fdb3151c09d0b4872c7b30cf5abec870f94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "217cc88ea2656e53cc2335eb621cd2d5a3e953d3a5a785e88ca9133eec0638c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4636de4e49b5806cce0e7c1e03e307166c4592c84ad95f46d709709a85561a2"
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

    system "cargo", "install", *std_cargo_args, "--features", "apply,lens,luau,feature_capable"
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
