class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.9.tar.gz"
  sha256 "47d2e35110c117681f267fe5ad543b0105a09434b38101c5ce2441f4cfd2ba7c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79b1800a71eaf3aef1e461b4105d6f1bdbcba919e6232911ec8926800ed18cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdebbfe79a45af7785c58f8cbfa3e9ca0e76835b9bc00d651510d0219635787d"
    sha256 cellar: :any_skip_relocation, monterey:       "76250987011fbf62e624e48542cd1aee38ad0482479a8257f47f5e5c684535b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "851d67fa337bb014d0dde1b906249762f16a9ea592e5f210223e4ee83d24fac6"
    sha256 cellar: :any_skip_relocation, catalina:       "e2b4fa3f70a85aae39d586cb221c10270ac7d1ea83598f433b238bd8d9770159"
    sha256 cellar: :any_skip_relocation, mojave:         "e082233ec21cccc714ce75f4d3bea950ea078592cf7ac67228df49544c82e9fd"
  end

  depends_on "rust" => :build

  def install
    cd "sqlx-cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "error: The following required arguments were not provided",
      shell_output("#{bin}/sqlx prepare 2>&1", 2)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
