class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.106.0.tar.gz"
  sha256 "ce7c3eac35d495188ceda49536ce1997a78a319a42d715d3b0b1712b57c3267c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "713a2e4614e9bf22eb2a21071f06b137e55652467a370e3477c33019e7deff94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c640b63c0cf23999922ff559070629717c4ea9d8e273a8698f88273e5fffd29a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17d3ada72787273fe411477b3e8399bdcbf2445353222a76aacf9d943a491e05"
    sha256 cellar: :any_skip_relocation, ventura:        "de85ab45dd48037e86dfe6729a8199a422c7000ec4c1d6c48ac70482863b04a1"
    sha256 cellar: :any_skip_relocation, monterey:       "4585691b0ac50004c6b09e2e4eb9b84b6b408cb180beb31215301fc4a980e058"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6f7ccc555d1024f1e10d978949e9827eb0018b96c4cd734ff3371d7f1454b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c38411290aaff93bf391248c6e156310360225ef1da46210696907db1a282c17"
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
