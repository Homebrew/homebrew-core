class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/28.0.0.tar.gz"
  sha256 "7a0efbab2d7cd7923ac4d8613d3eff4b4aa6383993f5e1d8edc393208265348f"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2140091f75c85fa2407d224cd50c5df4cf0e6ebf4f912fc58c8d4d3939638004"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f1b48ee7b2aa0ae4a9d67b6e9bb2b342412b46088726b4d25c0adb6324a6dee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59e85f23943a5d8ac294ae4cd6c3020d47f35192fb15d33876b24a8fecf75f0e"
    sha256 cellar: :any,                 arm64_linux:       "edfc05a3a876edf7778a0ad36594c906b32fa9c2182b1b8ea4e4d2349d487903"
    sha256 cellar: :any,                 x86_64_linux:      "23dbe2b5b823e40b1793dccfa7f4f0fca43bd8bdcce0d67199cf890d947ab686"
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

    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux

    # Build `viz_static` without plotly's build-time webdriver download and default the
    # runtime driver to the `chromedriver` cask (`WEBDRIVER_PATH` overrides it)
    inreplace "Cargo.toml", '"plotly/static_export_default"', '"plotly/static_export_chromedriver"'
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
