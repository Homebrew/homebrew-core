class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/21.1.0.tar.gz"
  sha256 "8a1117e62779f3e47696e9091a2293240d8019b80cb8f58676ee6dbc402e1ef8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68a9a1d306dd166a0efb98e78c1874b54f87cc0fb3411b183e7e46c6c0c70bf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba647d3957aeca2f7da0cec876066cab55ac4c7537e628453ce827fe0b8049de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8b52f5c5753a52c4907c5ee66afad750a51409724db0ec1713c8441136e320"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1bb71a9a1393e18d384699f8697dbded2abff371f2bb15c453f1c66f2c352c"
    sha256 cellar: :any,                 arm64_linux:   "5655c05d827d3103800aad81085065d4eaef69cb893185b863747452de807b94"
    sha256 cellar: :any,                 x86_64_linux:  "a3f937de1b8f182957f0806045d17810d115acdd13bcfe5b166dfd50eab171ba"
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
