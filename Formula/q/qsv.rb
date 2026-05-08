class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/20.0.0.tar.gz"
  sha256 "2ac311eb51edf1a161bf7e8f9f01c17ee72656343ed6b251531e7b4d60e51877"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "688dd7474ac5a98ef5a9db8773e5e71974cd7e43bffdde366b224004cb09fb0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbc7873183f0f2857825a0d51df3bfc0874674234e2c3558178a9cbb1747bc6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f1b0462967a3d6259d1ca3f5e8ad0b5d69e6fe5bf3aea8d5e3622f3b3f0077f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e0560df1bcff2c0be0813c7a2bcad541bff84b18be9e0c0ae5857377ee96d8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f825c586232d115b30f25d494212f2a88b0c1485cc05cf3d84ef194d428cf9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1becf303a23c621b1fa762df2834053809ebd7a9f3736c33f27e68375a44fdc"
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
