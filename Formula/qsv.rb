class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.87.0.tar.gz"
  sha256 "8ec0363d941d351c8adb15ba786b82747219573a4c1147ee5093cb9c1a6c054a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27fd785b46fac65e1a4e7f0d05b713ed6f26cf7df27842d0b3cd1838a29594e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce526a15b1d6da7e1ed969a64386e8ac536d1a01adeeef863c819ba41f087b2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a82c890e6eca44b2990ece25a7444b17055bf6f74b7ab2f22cba83a3e1b054e"
    sha256 cellar: :any_skip_relocation, ventura:        "e8e70e16508a3a224c68bab947ec440aac46f600c3c5f8557c941f40d9fb643c"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6692d9719cdcfa44b14c8c60ade92c5b8ba5970cd9dd633a9365747318ae3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "59c87fb39a532fd0a87c500e3e743a5d29f8e6abb3298ff5143daedccfe8e259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "913e44f95da33e7664198dbd6f46d94318695476ef8ed291f661e7f1c179677b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
      second header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
    EOS
  end
end
