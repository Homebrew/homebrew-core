class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "25191f91d9453402f938956f8ecd7cd20236382327902310792626ac95937366"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83050c7c49a78ff10bc330103e5ad44fe02d962a20cfb9191f83669137f6e486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83050c7c49a78ff10bc330103e5ad44fe02d962a20cfb9191f83669137f6e486"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83050c7c49a78ff10bc330103e5ad44fe02d962a20cfb9191f83669137f6e486"
    sha256 cellar: :any_skip_relocation, ventura:        "64cd57648d55e3df78b920f5a29325d20c1e4699ad6d60056ff681d321f72b71"
    sha256 cellar: :any_skip_relocation, monterey:       "64cd57648d55e3df78b920f5a29325d20c1e4699ad6d60056ff681d321f72b71"
    sha256 cellar: :any_skip_relocation, big_sur:        "64cd57648d55e3df78b920f5a29325d20c1e4699ad6d60056ff681d321f72b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc7475791b609fa4f72a5250b3b6e6738b2e24b8fae6643c294d048e8af5344f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}/skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}/skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/skeema --version")
  end
end
