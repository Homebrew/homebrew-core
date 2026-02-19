class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/16.1.0.tar.gz"
  sha256 "f2edbf740677f2d80da55b73ee4fa620521702d6bc35a559f93dafa9b1bc58ab"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57d455fd532a9ea9fbc4422938ac697efdf6b8470e48b829921002b1e823ec19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82fffc444012513f498345b2d952357ead0054005d97fad013ec1066d3571b4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa618a959a559614ed936def6fd7fd081cf4cb9b158145b11b4a642a6a01c466"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ad06bfe23bcbaeffab6fb85f3ebff5831b67420b08f4e94d1ec310654ee7bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c9f75c99f8cde5e942024b31943b828b56f583124400cdef273b5d3e552c766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1816f69a4d087da7dd5b1d3b4e9d1c4089d7ebe6a7244a090634d0f9e6446772"
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
