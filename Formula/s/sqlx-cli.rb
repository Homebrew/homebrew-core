class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "c6a32bb7d733fd598ba7473da9f82e9971557302e180ca3da0b1e29028dc9027"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17c46172b54aa2fb1e0e4cefb06ab0736bd223fcccac60f061bdd55e66aaf2a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9673914ecf85ede3a6076d57bad9caf28df9a39e95af7263da8559f4dbc4df6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0f358c1c19ad0dec41e48292a9971ff844905c9f82abbf809316f8a4b4d5478"
    sha256 cellar: :any_skip_relocation, sonoma:        "aabafa16b518a697e5169c2e4d1f00a789fb396ab6b4dcd8828f3e95eaa833a5"
    sha256 cellar: :any_skip_relocation, ventura:       "309ed400ad81629058d2128697ce70ee80ae9b411fe16e899a2a9f4807260beb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3464997e93de30ce3b413adb8115b8917b9b538450aa0cad7cefeb2734ca32ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3934e22542a2706089c12fe6fca9c41c6ac49ea881a4b60a780f4f29516916dd"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "sqlx-cli")

    generate_completions_from_executable(bin/"sqlx", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    output = shell_output("#{bin}/sqlx migrate info 2>&1", 1)
    assert_match "error: while resolving migrations: No such file or directory", output

    assert_match version.to_s, shell_output("#{bin}/sqlx --version")
  end
end
