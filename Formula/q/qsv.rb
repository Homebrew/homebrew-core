class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/8.1.1.tar.gz"
  sha256 "5c929abe3ce9945de1a492e32fddc73ee7e786a0171ddd816ff0b06f5b77a59b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b579dca33f502fafeb388f53fa349ec8ff41f14fae23576d527b26c8f1b0a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc91aa617f5373590c13047006b2e73ef7be1c101a490cf46294c6d88e8c05f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d82390dfceb1170462b902f0ecd4d63440210298b0c298ca4f3f271f737c096a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7acaa5f270d0874252f20bde4f391af0b8485d81ef8dd84347affa77c6b77c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0029c376a47fb4d804e9b03cdf01a2e264b227d62c07826cda4c6e4d0059629b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78e5f9f37c9bd5bc41391d1d7879235366d48f787b5bd18509cc3c72a2625c9d"
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
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,
    EOS
  end
end
