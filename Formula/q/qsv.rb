class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/10.0.0.tar.gz"
  sha256 "7c263a9ec84e97fa8879698f6087f76ab97a1ad4b5a7794afd61d9c31c684949"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b84d4dd1a28358f886b538ff0bfc085bb521797bb8abec5cd14a4c11151c98f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d119af71b3d57ea7575d76c8fa8942a2616c97d09ded444c56beaaa28d333365"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e486fc9ac9a9e0c83fd5d4293f6515e4ccc03de69887d552ca241de97ad15714"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a448a18049a1b915d5935c6ad90b311f33f13460e1d6a7717e0873c441fae97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "767c9ba44255cf8f216480f84e3dc3f99805fb304f2dc34042ab87ac03aa6a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b19f14d97a7530d61df6a66b179df4508c4a32ed8db104a7d8f3e05dff9ad72"
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
