class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "79c9457024ccfb56bf7247dee88fcf58a2b1a671fd1718f70857105a51654517"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "59007048cbe47e11e566d3b3950ad05f1b7501cb13bae573f3f9d82fdbeffae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c17e6175dabaddc7d9e35fbb137c6ae3286d68d336169aaadce8a0bd93366a1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a8f547747704a5e1c591e0f1406dd241b35c02d1c3c05875932272157343362"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb48f4f2bfbd51e84ff37a760f9a8ac86553c95ddde6184d4212b684ce9447b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "58accc035ec2bb59fb334032846e5d2a17df332963d431352cc27f843fb0c931"
    sha256 cellar: :any_skip_relocation, ventura:        "27c265aa68eb9ffb7ad563ac2def027ee5d3b675c1c984d8da315614bc7268c2"
    sha256 cellar: :any_skip_relocation, monterey:       "40dbb8804e426858f88d13f6636de346cfac679c7f2dc4de03e66bf7c37682be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3616f29738d08f71e7b6121cf26d382dc1066a257b11cd255cec94e68fefbf74"
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
