class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/9.1.0.tar.gz"
  sha256 "86af23420dd97862524cb4c1a2c15b56aa2153ac4a7a0c6025a5d40cb4bfe873"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "124b9f703644340f3e8bac4b785fdef9dd20d3d8a84fab1f239ea5852f3e17ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ae032c2ebcef35fc11a0641e20cf7e824cbd070dbccd4a05dd75afd4884675b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea2dcdb2d20ef0a6e5724c426bf338b9f6a96dad5d0bc0f302a2558845882466"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb54ff79572e2763d2027406e974cd42a63df8989eee61f75bc4d0cf20af7e4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2832eb5387e52571afc5d07a040dbd5be6a25b39fb1bd112636495f3115e589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1235e00687b542834afdd8dddc16af55d5b34f2ea729216e0909754478faaa22"
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
