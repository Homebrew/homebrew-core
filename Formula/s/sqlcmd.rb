class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "cbb572251ff514ac0cb95693252f29538b0e4031a3b20a20664a75c9e86d7248"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4c9823d564b8b033ddd8b01f06a669625019c6dc399fb30e9d32805574ab167"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbd59e90fffb35a63d3abe0271b966c03e4a784664b1b15ffbf9c446c73019db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4513217092698fc0ed4c7adc6f9e207ee74a42beec33b4d8ab57e5c369a03bbb"
    sha256 cellar: :any_skip_relocation, ventura:        "d3627c405d4c550e6548e31bc863a0a57670dd4bb0c79ccaafd5f09afedcc8ce"
    sha256 cellar: :any_skip_relocation, monterey:       "e5162b747dc00dc136e95ed48bdc600e95fb34eeab4b822a74d0eda60468b947"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e1edf24cb8ff391d4394c378a9b27666606983beb994575761b3de4559daea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c18e9ac3b08fe1f7357a09542fd01e037de6a303756e95482761a982c0172721"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end
