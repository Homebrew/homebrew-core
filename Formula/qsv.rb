class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.86.0.tar.gz"
  sha256 "f53a3dc52a6fda9fc4dc192781849a682c7fbfe62312a5537ee3cbb3a5184871"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c481528cf37a3e8f17f631c060ab1012def061513efbf25cea0bf8f96626106b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deeec963c73d816425726a15a78f3ecd4daf61e328a5cd9abaeb54311c978ff1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2d9ed28930d9d568f643c36dcaa484858763558af1d2ebd194cc18f0babd735"
    sha256 cellar: :any_skip_relocation, ventura:        "4bb93e714494a9ef0b000cf5212dc7639ee1aca528af2da65668afc8c630dab7"
    sha256 cellar: :any_skip_relocation, monterey:       "828d96967ceb62153b6c537f7f617069301a563142bb1b6be88953a5c72e4916"
    sha256 cellar: :any_skip_relocation, big_sur:        "d63bfb2232f0b6772a8dce47dc00e82d0d3a41bdf4b818f00da70505165f6e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3288b508ee442ff65f596fd5af51201a3987e0256e8d30b6b0a35ff11f16625e"
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
