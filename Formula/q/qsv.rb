class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/29.0.0.tar.gz"
  sha256 "0220154ed1ef58e0124f47cd96f9c6dfe00ab133f8a187c9eaec9e3258000693"
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
    manifest_sha256 "6150eae0e9ec617e65c59f2889288ff30a66040cd9686ecc6b47d9fc8ec06aa9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aca813ad12890400d74acbe7fce28317ffd27ae03ec9b91ecb4de90d6a7b34f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc26fd62dce9f5960e871a93a6b039dee3b60c275b4987c6e6b05e38ef1e3095"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "731db751c3d76e4866f1982446031cbe53f2f60a29fe9f139e877504aa3d60fc"
    sha256 cellar: :any,                 arm64_linux:       "a1a08bd7f62cd0a7dbee62d8b12d16cfc78f1e9bb71257311392fd63b3fbaa79"
    sha256 cellar: :any,                 x86_64_linux:      "3d1593ddfe3fe0ee2c66439a6d3e8ffab759014fd4419649c5293c7ead6785d8"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
    depends_on "openssl@4" # native-tls for the `viz_static` webdriver client
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Use explicit CPU target instead of "native" to avoid brittle behavior
    # see discussion at https://github.com/briansmith/ring/discussions/2528#discussioncomment-13196576
    ENV.append_to_rustflags "-C target-cpu=apple-m1" if OS.mac? && Hardware::CPU.arm?

    # Keep the large Polars-enabled build within CI time and memory limits.
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin"

    # Build `viz_static` without plotly's build-time webdriver download and default the
    # runtime driver to the `chromedriver` cask (`WEBDRIVER_PATH` overrides it)
    inreplace "Cargo.toml", '"plotly/static_export_default"', '"plotly/static_export_chromedriver"'
    ENV["WEBDRIVER_DOWNLOAD_PATH"] = HOMEBREW_PREFIX/"bin/chromedriver"

    features = %w[distrib_features lens]
    system "cargo", "install", "--profile", "release-luau", *std_cargo_args(features:)

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

    # Luau callbacks must report errors rather than aborting across the FFI boundary.
    (testpath/"overflow.csv").write("value\n1e308\n1e308\n")
    output = shell_output("#{bin}/qsv luau map total 'qsv_cumsum(value)' overflow.csv 2>&1", 1)
    assert_match "Luau errors encountered: 1", output
  end
end
