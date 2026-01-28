class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/15.0.1.tar.gz"
  sha256 "5ca3a5d3259176d468002a54699f93341f7feff115a26f9a1ea6bb9aa55b24c0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99757f5a1b369249c116db508d11f27dc57e216355c27f39c9d506674d26ab04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24b842c32dcf71267c869764b76b3362b156fd5d633b7a9e7835636f60212a9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35a840908d8e612863d67768df46529b62fdd6ce9b88cbbcc87479ebf7e3a687"
    sha256 cellar: :any_skip_relocation, sonoma:        "183af23ecd6690195757271853dff9b98792a3c811459b1e559a7627d9f71b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be384fd95fe77c7cf1fbd05aea9ed182f196d4a9b21b96a37de6094762a619d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01aa50fef0486009d9e200e7cb4066aa744c945a46499a3764e51091e452304d"
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
