class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.78.1.tar.gz"
  sha256 "35485b5f2cfc85f7a79873b79d84ac822e825da1b308dceaecee30815fe6006c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a186ca471fb7f13f76f450ff73e3320c300c0f6431ef02bf36a09f2cab5aa10f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "870f005647776c674eebaf81dba2f0385977ba90034c2bbeee9621d44d0da22e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0aebcd088a7bb8001703301a9d641c77eee99c91cd07779e2728dad1c9ea388"
    sha256 cellar: :any_skip_relocation, ventura:        "b89e87a56fbf72f9678e93c866156c00cdaf33a1a717aa8bb9c7962b34378705"
    sha256 cellar: :any_skip_relocation, monterey:       "bfc85a441c9d3c187b3b2876039518d1c38caeea8cf738617d7b033897cb5957"
    sha256 cellar: :any_skip_relocation, big_sur:        "876fc7fd2a33da76ac33ab22509568736b26609ed6f128dffe1d08ac48461e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dedaab42c126943a5516ada9de5026c0028a0947cd8d6239d575ea229a9e0df0"
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
