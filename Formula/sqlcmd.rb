class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "d5370a1bf443e1c2db6bdfd5f40bc97641ab49c7a8e382560d2041085b14ca94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c9e51a767ed3c3266d073fac7e9ebf93f0ccddd5a6fab637d061a9139003269"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591c1d8fe668622d902b75ec9ad10e1415f1618102f25faebac182a654ad994b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8145796ccf011ade5caccc8e397f6715de86b320d2030b92d4c13b60f493b05"
    sha256 cellar: :any_skip_relocation, ventura:        "39f040f63efa206e0191ece3b8c8732111cb68251004fc8b52c3444e28b7c813"
    sha256 cellar: :any_skip_relocation, monterey:       "d8cd0bbca84b089071004d5b05c83ac20c727876c404256094199d0ab28836f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8a6c7448d1e4b7f8fec42ddf9e1f01ed58561cba4c099cc462e0d08b82d237a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "098369fca8d3161de27dafd3da524369f85c2ad194730c6093d18f320d51e223"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_equal "sqlcmd: #{version}", shell_output("#{bin}/sqlcmd --version").chomp
  end
end
