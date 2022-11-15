class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.72.0.tar.gz"
  sha256 "70a723e9b83f04e7cc84a61845be9679fc4ad5ca1a3680a0b56afff5366ee102"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4433bbf444e8e924dc3b7983ceafc6a0533cc12c855e666ce359686928cad53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55a751e11a8083f7179ec8d6e00156399d249513f9837642f5b987990b3d9e92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c39ba1c65532c3f6e64f2ae0ed9feb76568ee3e8d65ccd3f0fa6496c832e32ce"
    sha256 cellar: :any_skip_relocation, monterey:       "17fc80771ded4aeefd9b938ab2387799a9012707b43b5da04f5d7387b9fa0342"
    sha256 cellar: :any_skip_relocation, big_sur:        "be0f427280c8dae54bd8ef668d8b74b7b9fb37fae57cc75e39e884722ca54650"
    sha256 cellar: :any_skip_relocation, catalina:       "69a3d5780f21d4a2c11401814d72a6d0777dbfc3f34f075b8e3ae59bfc372c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11783404324b9d93e844fec08b5e0123e5199341578f25cedc2ae7c7a576bdc9"
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
