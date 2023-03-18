class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.94.0.tar.gz"
  sha256 "1c105c0a8c24fadef245faadee9fd3e77b82342f438e0502df18624cf06fc4cc"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c13476417f0169e4b3943120dc828af3f026ce3e0e71cace25447baebd076751"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "727f4773ac0a46753f0bac2a38ce4bef75a53011fa87ccdd0fb8e93eb7af03d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b62ab3e0eb599dcec374a302253cd4c090c6cfd25f769a86660ed2d2b234520"
    sha256 cellar: :any_skip_relocation, ventura:        "2a516cd8c17ece93efd4a55761621d815c613df97cfb9a2f6ce1418ce73d4d89"
    sha256 cellar: :any_skip_relocation, monterey:       "b5e51f1ac322b8e25960eb8573d82cf6d6b5820f50b22f8a1b6e27223b022bc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9ddc557b9dd236cf855513360c56914bf29f2698df5159f1eba02b2a77a48ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec3b39ad07f0f2634e7854a7dbd37ee12aee85b717404b94c6b5e2170f69c2b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end
