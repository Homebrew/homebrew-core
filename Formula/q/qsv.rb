class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/19.1.0.tar.gz"
  sha256 "8f11187987fbecc855f32a2e010915471bdd06a67ffb6132a4d62b15fe4ccaf5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0697eaf825b6f36705e013fa0afc544f612cb78a8fa40dee0def46b4b9a3e772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "014d162f1df76d6d5a79aa600214736e40a2ee1355fd4bcc17846f2996689e56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50094b0708a8eedb8a7a0f316a110193655b309869234c2c6ce996ce724cc1e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f271261da020391b8744b06c6c31ba94121539bd6eea434e66589f4aca601fbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaea3fc71c28e767bb273c15c799e0c4850ae753cead133f93c85cc6da03e138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a24062134087349f78e6552235d329b4dfee7ef49d33d9d3e8cc25a036c5ff3c"
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
