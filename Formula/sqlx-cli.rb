class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.6.2.tar.gz"
  sha256 "d8bf6470f726296456080ab9eef04ae348323e832dd10a20ec25d82fbb48c39a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d795c06ea78a790188c80549289ccb5753a8ab0b9fe0f9588bcd366c8431399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9b4dd160c054bcf007083793f0b0e30f5a4b66f058c1ac2df295f1860f0a288"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c7e5e050a955a294574b7f25603625bae94710a17f29e20a9975d1e512ff8a5"
    sha256 cellar: :any_skip_relocation, monterey:       "3795ca460b8f0c215ac7dcc88de69fd6ba966d07d28a224bf6a4ef49d823a818"
    sha256 cellar: :any_skip_relocation, big_sur:        "a452538164cdb9845f4d0b539462674d924392889d253ef30498249ccbef94ab"
    sha256 cellar: :any_skip_relocation, catalina:       "fc5953247af6e6cd904e77506d7efcc0a89675b5e2049ba5dae141df5bbe8d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b125a7455d03bbfba352ccdf2d1fea9c9632c616c8bf92020e41c53268ad0113"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "sqlx-cli")
  end

  test do
    assert_match "error: The following required arguments were not provided",
      shell_output("#{bin}/sqlx prepare 2>&1", 2)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
