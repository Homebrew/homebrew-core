class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "2cb6e633830917ff7730cf1cb03457796a9a6726c3ce5672db9c4b6420938066"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "316148ca8aed3f537dcc064e0147933fb6a167ab869041665041e36da69c2828"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "316148ca8aed3f537dcc064e0147933fb6a167ab869041665041e36da69c2828"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "316148ca8aed3f537dcc064e0147933fb6a167ab869041665041e36da69c2828"
    sha256 cellar: :any_skip_relocation, ventura:        "5e26fc8c22174bb96df5715041dfaf5894283f95f26794e19c5c8809d87d02c6"
    sha256 cellar: :any_skip_relocation, monterey:       "5e26fc8c22174bb96df5715041dfaf5894283f95f26794e19c5c8809d87d02c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e26fc8c22174bb96df5715041dfaf5894283f95f26794e19c5c8809d87d02c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2309d2c547a06fc098fc6256241c3a87f0abc8c2596f4a5fbbfd3f039d2aa7e2"
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
