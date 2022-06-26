class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.6.0.tar.gz"
  sha256 "54cd83dfbc09e689a97f06d42359400b9301570e9adf4f891fea53c0382d9dcd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8ad28ec7dfad8dbedf9d1fbd5df9ae24a71a35a3e97b9c78ec196e061725101"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be858c81c7820fa6df90bd45f11b68f4ec190a2615178704a7f15ffae7028fc8"
    sha256 cellar: :any_skip_relocation, monterey:       "2de74d80fee9b908c5a6711b3832103e62b8b5ae8242e7c39a638f6e89bec053"
    sha256 cellar: :any_skip_relocation, big_sur:        "4069aa94340b7fa3c524c8033bdd63779637f26a57e7a471c604fbae9edabaa7"
    sha256 cellar: :any_skip_relocation, catalina:       "6124ddd0f52e8a9c90ed9430928212b8a44b46843c40dadc62d4a6336bfd8c83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "118d5c3821d8abfda535a3e44b6925bc304065e62cd8e34bf2da592b9899305c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
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
