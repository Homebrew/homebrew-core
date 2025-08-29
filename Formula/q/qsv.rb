class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/7.0.1.tar.gz"
  sha256 "f6dc3ca7dc227a3ff325464c8861cdc3f1e3d051857bed3882ba041804af4822"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90f1a4eb8e70ca23a3eb60e9cad88847892d0bd8ad2107069b27cf3b8899a8cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9629fc3fa5a64d0e94d8058bc3385592ffc853d633a4475a43dffed4760c2909"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4efcfa4e20ae3e09c62bc75abae46e1a0e10b7a44156d498746d6220c9e24f97"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fcbafeec43807a8226ec161464966ded003bbce13a4e3361021add956ea6adc"
    sha256 cellar: :any_skip_relocation, ventura:       "9aeaeb697b32246869a358a8a792cd130a86a86dad0ccc370f9f4b85369215ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd148c0c931c988f4aaa7de659b7edfafb8aeeb12d0ed7d64beeb9b662852f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ca24bd05fed268806ec6ac734fb7e36ccf100b71816f6e93f972c1aca9b00c"
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
