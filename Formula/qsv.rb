class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.62.0.tar.gz"
  sha256 "815ff78ad54eee874027336fd24fe55abe5bc4efa9f02fd79c65988e7a9c4022"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86b2be6c6b22fd2a4e8fb946d8f4131170592ff996cdb47d93d58771a1b3f783"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5316783efc557ba0c7ca57391433febf9efa2b8d5d0ce59dab1ebd2c02ce4623"
    sha256 cellar: :any_skip_relocation, monterey:       "9a131a313564f857625cf8d4a715727f09ace605925c90e98269bf7eff4fd139"
    sha256 cellar: :any_skip_relocation, big_sur:        "adc501915305be933a70c4f16625435f6e633d4ad5baf40dc9f4b4185d9d9636"
    sha256 cellar: :any_skip_relocation, catalina:       "b7cb60698dff4c75fa9c5544031f891b98f81d31de32c2ce33284680b2400469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "648c47d5db0a0cd1989ead722f3b7c256503726af6dfc054ad3c3cd8cef5a357"
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
