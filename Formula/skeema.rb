class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "26cdcb663514ef7515389b1bb09d5644ae6230e4b1ec3c19d3cd9c4b7ac9743a"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e6291e61746c245f37a2e499de2daec5b4b6812f36410c6cd410fe0c995200c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e23e0ce8d4c4f235a9be67092457a89d70d52304a762648a0290c53a6eb415"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e07e12841fb574e34021c42ae7555d0bc49257e97ae27c03ba070a44aac1f8f1"
    sha256 cellar: :any_skip_relocation, ventura:        "2b67616edda8abe073693541284f13ce8d446b2def454e72e43277a186f82414"
    sha256 cellar: :any_skip_relocation, monterey:       "f4ecc20184505eb6625a38016dff759d50037c8fef321b6a0f42f27e94134bde"
    sha256 cellar: :any_skip_relocation, big_sur:        "4833db47db271837504d6c233d2590b603ca55e1981aec11fefa7ba3698db9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a01c55e4ada96a468c4f87f01b4d52223f216bc2a695113f4cd53b1a6c0a2991"
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
