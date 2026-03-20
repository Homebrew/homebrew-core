class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/17.0.0.tar.gz"
  sha256 "433f0ad953ae04ecbd2bff737b824c2b1aff84c4fdb675c4e8184335c806d36c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5394865618e07590fce0698bb1ca2dbab10e324afaa74ae9fbdbdfb8d1ee2a64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ae742a9a4f355a2e5c0e56366f6b4805d00477453f4098b1af6e0bef0c319cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66f67ea410278710a7e074888d117061c58836a64a6995f17fd57201f1e8caa"
    sha256 cellar: :any_skip_relocation, sonoma:        "09a0110b8a627817842818cccd8787050d7d21f58a96c3bc4ef4ed50f1907745"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7348af6b0eb1ed197ded3f161b7fdb72f368450bd2e21248e7c1b69f8182da6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfab3df20b2f5ed6f11c0e1c068dbeeee2beb3a512f14d7879b6940a0fae3911"
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
