class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.102.0.tar.gz"
  sha256 "f75265ee44473ad5ff287e5009f818d3ef06702fe4b238b1ea3eea3d973a5166"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc67bbe364cb153816226069d8dbef557ae163be815464032e2bbc2d512b8572"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e9c62a29004bdecc780e9ebe5fc82e87d6caeb1514727e56c4905a2a0fe548a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6928ddfd0e925ad1b64366ad4f3a2897b1332e717cfeb67f19c4c8f203f53bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "690cb661a8d77a69204313b148338380e1fd129ef6c3bc9c269819760388bdfc"
    sha256 cellar: :any_skip_relocation, monterey:       "1a44310211980b33ea87ed31d9709a7b8c70e9e7edfc3d5fb084a6949f2f58a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f600575de55483620b3484bfa02f73741f56dd8ad8f09652cd77780c4ff3e9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0daed3c0d4a2ee8d023c3d677e5dc782361bd41f63cc4b33075a652794c14b9e"
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
