class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/22.0.1.tar.gz"
  sha256 "b4c40736b74375ac10340d8ddef0bd715418b9b22b8bdff395b59f07a7126b09"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be7051632decc060935756bc0ce2284d4fdfa9dd3de4967bce1fb0732c315f63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec664433eb9a02264d8262569434ef5ecaca7efec4f6a8ffc9f26d213c6baf89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d85341dcfcfd48d720a7abfb23c4c8ad8390eab33077ce6c9459280b696aee"
    sha256 cellar: :any_skip_relocation, sonoma:        "63cf2c82751f9317ade5ca3079ac4f2ace1b43761ded00654afdd8298bdc6cc8"
    sha256 cellar: :any,                 arm64_linux:   "340f99693ce4cb26ae2487dccd7a47d361b3a9d4e9cb3c868271d6a4b5d13ae2"
    sha256 cellar: :any,                 x86_64_linux:  "3581e88eb24ddfbb71abeee11d0d89e2ad860bc1d6b01b705c9c78abe427257f"
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
    assert_equal <<~CSV, shell_output("#{bin}/qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,n_negative,n_zero,n_positive,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
    CSV
  end
end
