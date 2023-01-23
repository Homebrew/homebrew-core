class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.85.0.tar.gz"
  sha256 "0e90c6e5bc59517673c4d9519001bb55564ac6a599b0406a2fc0fdf9634983ac"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dd42e79b3edaaf4f38c593e9e41196feab47db6127060f9bf06eaf8529c2182"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "395d97318047ee9c701c67feb17153756610a543afae9850756d38ba6dca785f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e6f0a8cfd55568dc0459f85a0913922ac6b5381af0ddc36e0d0e278c9be96b1"
    sha256 cellar: :any_skip_relocation, ventura:        "92e1d2400526d01880e60cda898af24808119167848c2fbdd8f8e2ed0e8c1659"
    sha256 cellar: :any_skip_relocation, monterey:       "b11e7490933947e71298362fdbb439c9f88b4df47300474bffb3fe9622a54ee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b18b0c682bf917b1fe407da339c5bf860adae922e3f48ad96910a3e02a1f5e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1658a7188837f6f3df271897235f049dd7c37aa4335914958bf1d44413155aee"
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
