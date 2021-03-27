class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.3.6.tar.gz"
  sha256 "c372573a6325288b9b23dcd20d1cb100ad275f5b0636a7328395352b3549dd71"
  license "MIT"
  head "https://github.com/dduan/tre.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "13668b5bbeaf1145c86689c0b93e35113b6e2ac57746e8265a53e5949992c778"
    sha256 cellar: :any_skip_relocation, big_sur:       "55bcd8b82d878b8ff7202d07dd5b5e8351a404aa2a689994a01b8e19307e5dd0"
    sha256 cellar: :any_skip_relocation, catalina:      "3b20822d27a85e70deef6b1dcc1c3704de8f1e31cc6dbf231df106807c1d214c"
    sha256 cellar: :any_skip_relocation, mojave:        "0fc2c04062fea68f557b07f128eb84c2c6bb6191e56674c0ff75ba653bbd09d7"
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
