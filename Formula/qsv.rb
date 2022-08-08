class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.61.3.tar.gz"
  sha256 "20daecb65b952a3376759e15a14c5c413a17497cdd17f9905566a15155096b26"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0f63eee4592c92df890db9a8b5d641c688f9b47a059cbdababde434adc51dfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c179f72de65911dc9b3c781a4fe6b9bcef76200ffe9f3f5d259f22b5c96ef5f1"
    sha256 cellar: :any_skip_relocation, monterey:       "d8eab312fb6e5a89884df938f403cb7906f8b8f2f83190508bafef74e41e5927"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8e221071887fa4eb3521ac0b7c18794f4c233f32090844bb90f134813fad8a3"
    sha256 cellar: :any_skip_relocation, catalina:       "3bf50701452ece7e9ec47069adbc73bcc849122bbb8a763bb0c1d3bfb599884c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5427a73bc999dde8c782dd36aa7dc49efff434bb930b0b6cd5d852d2f4fb7bf0"
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
