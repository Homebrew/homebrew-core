class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/15.0.1.tar.gz"
  sha256 "5ca3a5d3259176d468002a54699f93341f7feff115a26f9a1ea6bb9aa55b24c0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa97593e119481c556a74c3e9bf5081c00017e7e55f5c91618f8a95012ec1050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f5b8d1cb2c6722e385d6d5f793bef63a5bd36399569538c1df1c6fadb59f32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d16b4b3a163668eb790e391a51bbfff2ba18171bca7755b4ae306f89dc4a4d8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fafb54adad9d2238249b5f34578a1fa80ec0187e87c5bc9b8e97256f036c675a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2bc9a1be833b5d54e39d463f86e91fcfe6fe07e707824957290058e168300a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "447a16f59a69c96792ea3fb62f77fa3f246cb6dac04082072e58d514a9436d79"
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
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,n_negative,n_zero,n_positive,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
    EOS
  end
end
