class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://github.com/dathere/qsv/archive/refs/tags/19.0.0.tar.gz"
  sha256 "b33887902348e454694ebe01c79a97c8babbf59ebba94386b7a749023ad7f1a7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c24288a1211f604fc0ae9815ea0fb9a50c5ae93bcb9bfffdfa9b169eaa1a2235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "174da8c466148af53a41f991d7a3340be439b327ca390256f403b11c48ec7472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97df5a55b7dd980efae5945e7e6d9517091852d8f0a63bb542fd3fb00dfe4f24"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce356e364a8a1977e94814164e5d70bf91cf52fab1e6f705c951f321c9ae7a36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e43ecfa39595be2d738694c65a7f3d0048f1dc50827d2bbab9ca46991cfac302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15f32d1cb93470badab6ebcaaf9c8264e0da16ad76fba4f6c31bf8bd9d21d50f"
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
