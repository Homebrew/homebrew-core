class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "c134f62de37e5b0e32d27219b4d5dd96ddce0b6aecafa22c1ae869128fa7b514"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10cf8e045b0e4bb71a56acb4afc492ab876db0e339297b52e438b2d467fe0f6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "697c293f7408aea4a9d203a49d7958fda3853fd1e8daceea3cb24cea0304a6a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11b83922a6bf6faa25b26d6f943ece71d92d0f6164a5143fc5635d775297a48c"
    sha256 cellar: :any_skip_relocation, ventura:        "f4de030e1f795999aba5b523f5302a21835bb52bbd7c4f0bd1230511bbf19ac4"
    sha256 cellar: :any_skip_relocation, monterey:       "5a217cc96c05262067c378efda34c0d2f294f0b87710b37c8f6ae0d203ed2eea"
    sha256 cellar: :any_skip_relocation, big_sur:        "99c7740bbeacb4305f29afdf609e8ad356a518424968cbd211b87b4a4385e855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "432230b370765722e91c94300c7f1e0eccb83c13154bb95ef3539bcac3de464a"
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
