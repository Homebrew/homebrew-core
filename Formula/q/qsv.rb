class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.123.0.tar.gz"
  sha256 "9a807673ad71cac12ee64521a45238417a09690b71cf0d0cdbdf44144f1ab8c9"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7dda31dc807c3f570e2243ac2088de865f6be2cb3d0467c1500ace468a14e591"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3c236c5234b2c10556b6c29c7c64abf8a3a57b309c45a65f530287f74df38b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffdf780f2cab24cfbc516770b6dff84f030f29cff6d38cadbded7d42b7474d49"
    sha256 cellar: :any_skip_relocation, sonoma:         "63f110b4f248c261e6a5ffdd7d53cc24df65feca4a7048020428c31053ea0b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "cc83c21f136c74dcbb46f92b05089dfa9d74cc1fcd60ac3df874985746575356"
    sha256 cellar: :any_skip_relocation, monterey:       "01bb36ed7becd4a54b42e86f87eb7e43f363ce0c20659eaaa504e1a1365549b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a79a22e893de13dfa03e0f34cb27a1df66fc914740dca669a0643e8f634595e"
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
