class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.114.0.tar.gz"
  sha256 "12fa3b54ff805ef9b6e72b29d8355b5b4085a8cda4042a1be790ddd1dca7945b"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9843b8100ffed883a92ce4a68770298d9b20770bf5423fc99fb2e921c0e58b96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee22a418081c874bdfaa5d8e6657428f887c5d31a0913940dd5202dc7d899dd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cef03f1ea667b6767aa69bc1f1d4e13a56579efb5668d9fd5af568e4567b8fc9"
    sha256 cellar: :any_skip_relocation, ventura:        "a2df9300864b7a2448efc6d5e773aef0b6228306b9fe37d39a4fbb35ee2e1fe8"
    sha256 cellar: :any_skip_relocation, monterey:       "3382595e4616aa00d5cf5415e84d5ea86c911f20a566e10bc6496ce9f217448a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dbef9f4edc2d606469e2d04f17b8bf81b38b95a6c3d9210f842ea329a97f606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0b1f85c57f48d36fa88e9de08329584f495a3ddd1c7ce22dd41a83e11b44cd"
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
