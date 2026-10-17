class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/25.0.0.tar.gz"
  sha256 "3e853384663b3df600da7596ca5dc242f7c67acb135d62802cfb9875cc0d80f2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bf75c532354c53b74424011935624030b41091c24b4da9e77fd17e9b508135d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ce5a1509f40fad062b79c9db6b94fdc3f2d81b166f1f62d44c7019da812ff47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ffd73de3dd180b98ef28c763fe81409153f4d794763d17cc5df5fb22d8af19c6"
    sha256 cellar: :any,                 arm64_linux:       "6ab2fae2531906920d0da898881f5cb2557580ba31369c6dfd582343db224ce2"
    sha256 cellar: :any,                 x86_64_linux:      "a0430c16e4039951f71aaef3d5c31d4088893aed38899df84294786c608c4a53"
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
