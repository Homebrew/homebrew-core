class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.66.0.tar.gz"
  sha256 "f4a46329885abf472c30655dc752c13b476897df98fe4fea2eab6da47abeafdf"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a2966571337eb548b8fbfb9ba1f423942140b9afb99dda276f1368bf38b6ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99ec87502c331f57f06df28a1e5b1125af81973379289cefbeb890fb8296e59e"
    sha256 cellar: :any_skip_relocation, monterey:       "4219396b7da02fece26fda9c1f5508842b2e44ad3a80d703fe0f4b82c9496f19"
    sha256 cellar: :any_skip_relocation, big_sur:        "95fe41c7b57d4f15274920aa2932a6d01d72d33b560b4da02736394e401af5b7"
    sha256 cellar: :any_skip_relocation, catalina:       "386252cba4689f0600bc2275a0b3ef01b4734660be23afd72fa823829eaa9326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8c585a010f6024a3f105407ed1769cea04a015e87bef4b177ca068fbc144f1b"
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
