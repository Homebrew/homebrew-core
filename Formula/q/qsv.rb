class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/20.1.0.tar.gz"
  sha256 "9e945ebcf525cef35591e5b8187dee9b9237282a1611c8ba52e650d5703dcfd0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42d9174eeffe00b99c76b9c2d0e90c3aa39ad01cc87da768fd63b6da4ff69157"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28e3c4f808fa4fe43d55796310cc9ae5bae0ced60270a6c4130e15a7d269b9c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc4d6c26d106e794167b1fa627e20fc18771128bc7a6221027433f9123e0cc63"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c312940b9c3156be76d0f10068645aa49443a899bd26e57e99d302bbce4968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cacb3b9af8d1fc3439996002036e9b86fc31e6bf401629ec4e2db044690bb00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9995c55149815c5c6d427f3d58d75c38f8bf3f0ed50967ca5963c7201785e60"
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
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,n_negative,n_zero,n_positive,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
    EOS
  end
end
