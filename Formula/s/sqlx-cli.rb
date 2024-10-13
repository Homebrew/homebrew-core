class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "89fc875ac233e25cb8da18d581f28a097e419949d0af876aab143ba620852ea9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f874214d8fb27df2f3bfb1479cdd259f2cbab8808d77b171d96af16ac57b45d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1c238a10e94db7777c013316fb503eed969fd6edad80091bd04b892ff91cda7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b88aab2146428c263aa7f20752b27fec3edd7e7784c2b0448e2be503e5bec3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ca0b0af77d7d65c3eb2eedce677502fe137f5436c75e12ae0e5b2f2bf4ba71"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ec46ef906952515ca3fdb8ec9b57440fb49fd8ab7d4643bb78be206217c8a35"
    sha256 cellar: :any_skip_relocation, ventura:        "95c54d98b04ac5ee315f6e352dce345cd53e4160632b827dea7500f97d9356cc"
    sha256 cellar: :any_skip_relocation, monterey:       "e6e78ca4649034854e10f8791abfd3c415a2a16eee3b9c4e3fbdf79eee3535eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656282d427fccc2a42201ac6dd7c35fafa1296cce1843562a1b6f16bbab01e31"
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
    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/sqlx --version")
  end
end
