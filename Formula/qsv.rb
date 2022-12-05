class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.76.0.tar.gz"
  sha256 "dd3a2f0d78b1187edd77c4d2d11c897fac66f28872079201d4bbe40b185247a6"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01a508cd1c17cb2acaa9b72c403642d85a917aedc156d763e9216e4e8f38b3ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfbdeb1967df79084eb8294c80be42a1b4f572729541462590a18e4428efd906"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3188ec7b48b097202069db13f9a510b46b876b38f3adbc80be9589891ae3f2c7"
    sha256 cellar: :any_skip_relocation, ventura:        "6352f484a764afe35bb5584e76c8c7823572e08a8c0ae3226f11936302b0609f"
    sha256 cellar: :any_skip_relocation, monterey:       "a48b712ec7059fdf9cd937ed37a5f81fec7c027b1a2774f2a67a7dd62134cb89"
    sha256 cellar: :any_skip_relocation, big_sur:        "98b0541ee0db1eef1fce88ba23941225d679a3baf057cf9d7d81ebd1ca0c3f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d433def6a4e5440d8bba5af5513706407b2ffd6ca3e200e8bbd8b88d27d5f1e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,min_length,max_length,mean,stddev,variance,nullcount
      first header,NULL,,,,,,,,,0
      second header,NULL,,,,,,,,,0
    EOS
  end
end
