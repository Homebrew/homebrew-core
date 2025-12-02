class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "075fdd68c42f753263990f7001b0fa24f20e1675496e4cd7c3408271a246875a"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e41e0f1aef29a2784c551c6f55558fb4c6208310ce1db1b16b7937f4ac087bbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e41e0f1aef29a2784c551c6f55558fb4c6208310ce1db1b16b7937f4ac087bbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e41e0f1aef29a2784c551c6f55558fb4c6208310ce1db1b16b7937f4ac087bbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "26539db6b266b2be11bbfd355dbe554956e02849952cd7210b203f13d18909b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a176bd8c9c84a89025faa55f2b8b2f07382ca8baf0ef5296a7a0120ff18be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97028b7cbf5f1d3d4776c38f9995ef5baa58a66ed6e158c9d35fc3237d6deecb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}/skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}/skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/skeema --version")
  end
end
