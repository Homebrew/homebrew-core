class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.78.0.tar.gz"
  sha256 "56642737ded9634bc800d663e80c41da42c55dce084082e1af04f329767f0438"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e4978f1aa33ad5a578a3da11b7794948911df7d6cbeb943123f78e3e309b321"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45e36a485ccd559944eba1a6dd3ba5bdc007f54b88afb6035012129ecc1c6f0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cd9896af3446c537bd9c0fea73369022cc464905a59a39040b07fd9ac29cb6c"
    sha256 cellar: :any_skip_relocation, ventura:        "185c2a438e2f8d1302ca48f4033ac55896d7e21ac9c0380eacbd600424da6aa5"
    sha256 cellar: :any_skip_relocation, monterey:       "40f47bb2b007e49e57f5dde2b2ff80f9ddb7d1d9fed44500742db2b7b6c6bc83"
    sha256 cellar: :any_skip_relocation, big_sur:        "539f29429bd1c0c8833f559a43199c55372828c676b8b4f8dd7ffbb6b34a1607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c10c47a1a450b46076e7cb454b0b7e4e7522a786eee98779feee192f3b42c82f"
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
