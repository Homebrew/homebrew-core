class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.59.0.tar.gz"
  sha256 "63a2fb2614eb2fe87424ad459bb9dbf5724e4ca18a0372e729d0bf2034e07002"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883f75985f96ecd880472a1a8bea62e774f8824b4c6b933f1881b982107d376e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7acd4ed436b4b823c0e23b16160483f108989721425dd1c9be39967af0af5768"
    sha256 cellar: :any_skip_relocation, monterey:       "432c48e0053fb486073ad5b5fe7165b0d97cdeed311dcaed0f05440bcbce6816"
    sha256 cellar: :any_skip_relocation, big_sur:        "e211a43898c3da91a842497518698017c0986bca3ab6311da608499bc58e5eba"
    sha256 cellar: :any_skip_relocation, catalina:       "15c02fbb5d68551a17e6899e7893bc6523fa409a348df479803e4a396e165dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "796972c1e92a39b811ad79278893a6851b0ae1989923bb5b4b6e2a65444a40df"
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
