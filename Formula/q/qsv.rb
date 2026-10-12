class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/24.0.0.tar.gz"
  sha256 "7db2e6ebb3c6a45c5604bff82291a957c62287a61e63aceb90c12335fc3cf8ad"
  license any_of: ["MIT", "Unlicense"]
  revision 1
  head "https://github.com/dathere/qsv.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1922fdbcefa4c646d725cfb706e21398c5aaf7bcec3f9e80a1b511e610ec47d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83da6e27db3ab33f5cc4ba3c161043ff6c31b44d58e80e08cdc96af100e908c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b11fbff09a6717c98cec732f16851eb2282706206dc85f1b47c01629b0442ad"
    sha256 cellar: :any,                 arm64_linux:       "3fb034c13511bd44566690514ce6b9ac2fc793dab52432e4bca29fdcd12f76c1"
    sha256 cellar: :any,                 x86_64_linux:      "0e2c55314bd62b498f6fc24a70e31a9d238e9a211adf2d120a1039617e680cf6"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
    depends_on "openssl@4" # native-tls for the `viz_static` webdriver client
  end

  def install
    # Use explicit CPU target instead of "native" to avoid brittle behavior
    # see discussion at https://github.com/briansmith/ring/discussions/2528#discussioncomment-13196576
    ENV.append_to_rustflags "-C target-cpu=apple-m1" if OS.mac? && Hardware::CPU.arm?

    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux

    # Build `viz_static` without plotly's build-time webdriver download and default the
    # runtime driver to the `chromedriver` cask (`WEBDRIVER_PATH` overrides it)
    inreplace "Cargo.toml", '"plotly/static_export_default", "webdriver-downloader"',
                            '"plotly/static_export_chromedriver"'
    ENV["WEBDRIVER_DOWNLOAD_PATH"] = HOMEBREW_PREFIX/"bin/chromedriver"

    features = %w[distrib_features lens]
    system "cargo", "install", *std_cargo_args(features:)

    bash_completion.install "contrib/completions/examples/qsv.bash" => "qsv"
    fish_completion.install "contrib/completions/examples/qsv.fish"
    zsh_completion.install "contrib/completions/examples/qsv.zsh" => "_qsv"
    pwsh_completion.install "contrib/completions/examples/qsv.ps1" => "qsv"
  end

  def caveats
    <<~EOS
      `qsv viz` image export (PNG/SVG/PDF) needs Google Chrome and ChromeDriver:
        brew install --cask google-chrome chromedriver
      or set WEBDRIVER_PATH to an existing chromedriver binary.
    EOS
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
