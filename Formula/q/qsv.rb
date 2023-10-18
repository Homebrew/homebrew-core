class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.116.0.tar.gz"
  sha256 "9eaba2a347d3b8f4ca595a9268c8858475e2411d3f60d92f60d8bc91cf81a20e"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e3f7d5077713ad79687982267851345626d878c88d6964ced447de4ee51fb74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76e36f95df58c657675ee19b8d1628d479860939e2d8a2dd6e9216a8c0ee3056"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae66accb75273f98b0a734093c554d1d1c4e394b23e2203235ce1b83cfe526ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6937344efbc39ed734e5aaf10aaa47ec6d8e31433cd8e08503009f37b474286"
    sha256 cellar: :any_skip_relocation, ventura:        "966c7be0669b263a1b26526ec09d2e86fd8272729ded5ac06ab9506bdd6e0028"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec95747b64a5a354f89203545d3dcd3b31fc06362bdb4ffbce1984015d87903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5a91cd5e0e20d55991fff586e10cd1bbb4af27b7926219f1d2786d705c054c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
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
