class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.61.2.tar.gz"
  sha256 "f2c81f12a8fbadf0893b946a8da59feaa604b117c67bd5b22c435f50e3ab8191"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc7de78cc0f7a4f5a7fb51aabaee8ae4a41cd1e8fbf893a371ed0457fb72030d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "376280db23581565dd3caf26ee56db4a8d94992ec9312e7d9c5e13e81cb3e8e4"
    sha256 cellar: :any_skip_relocation, monterey:       "2fcad968cc7c1c268257ae49bec0f20f06b5ea151c9c61de2eda6c7ad99dbe79"
    sha256 cellar: :any_skip_relocation, big_sur:        "41d7309c560f291600b562e4b3fd19160900313bf554e8788b37c059261dac2e"
    sha256 cellar: :any_skip_relocation, catalina:       "91a22e21e32e6f9ad880f98ea64e74beda7e4d72813b73f10c4b981951f2cbf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9572024df2f04a6efae936baeddfd55fe8179e11905fd6541a50d63e7f8f2ac5"
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
