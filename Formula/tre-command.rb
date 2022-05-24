class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.3.6.tar.gz"
  sha256 "c372573a6325288b9b23dcd20d1cb100ad275f5b0636a7328395352b3549dd71"
  license "MIT"
  head "https://github.com/dduan/tre.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1bf5a1896ba6220d8dbd16341a21086c05a17f799dde7a1c0e3ae4b026bea63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27cba0da0af50bba24136d9522eb88378be6a41aa08fc8e7d32d1e8a51e4a566"
    sha256 cellar: :any_skip_relocation, monterey:       "cf873408adf07435e41ea770baadccddcf62218e80c5c658cdab2c799410e0af"
    sha256 cellar: :any_skip_relocation, big_sur:        "95b74502a71f06fd0d836710b7fb706cc32348fe2db788b4ea4b58a39690e840"
    sha256 cellar: :any_skip_relocation, catalina:       "65fd03a686ac215dcf9228312238b4c0447823f99c9a45074387d3322b9452df"
    sha256 cellar: :any_skip_relocation, mojave:         "f1f321409d7785cf56267748682eae4572a99382bebf1fd187ac30e70c5cebda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c63f6f75340e4dc28ee40123dfb50f58208d65a70b6405a9673562947edc039"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manual/tre.1"
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end
