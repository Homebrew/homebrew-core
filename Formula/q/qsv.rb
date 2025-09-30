class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/7.1.0.tar.gz"
  sha256 "9340be11d3b100c48cd1f35cdd353fe5234b9c6c7223de32470df05f5e0c4ad9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "652d98678932a4cd78d123cdb0efb3619956839218ef05cd841f0a5d7245f14c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10065c4203536c72099b305d2d26fa836bcd3ab7b66c2331d5478d812a0b55fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a12edf9bc1820f1609d00fce2ba509a1b6bb7fd1a8946753332eb62e5479a611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7b9d9d0e6ce96e55855928f2fccafb38007a5947e2d79c018d3370599b971b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0ca7eccb50fc5b06869ac695cef1175017980e3bbe32409459c897ad6e3c9ac"
    sha256 cellar: :any_skip_relocation, ventura:       "de09edb31972a0f6f3de986bbd6cca39e198b0c852458f0a46cd9a00931ea56e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "865a67e2a957a80e8b531b5a8f73c96514b05e6f534c1b55038c64eb68f6b54b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "105ff6cbd55f363e23b665d5c83f1d700c01d2ff11ccd392ad4fbd7880d2f517"
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
