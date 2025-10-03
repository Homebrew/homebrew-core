class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "75d0b4d1f3081a877c7b75936f069f9327bb2ceb4dc206f5a7fc89e0cd9bc31e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5864ad0460e6160909392fdcf5b606b06c3edde717f24d7188eccc09e6036bee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54230ed1ed41400afdd696fb0883096bdce65b91d9e7fe015177b5ba44ac22ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afb223fc9e104c0bfc99b6661ff4e458b9514eb1b1ce029cb0e1d9483ec64da8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12cbddb5d45554d8d553ac0d7082d992bd9bb71208e9dece395991d81a4a92e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdbfce8c38a02084c3cb88267371c470aa8154df798ab046a61a491fb616cbbd"
    sha256 cellar: :any_skip_relocation, ventura:       "63cf0e3541f8472296dfb4664cb62ecd5b0beb131f268f8b971f444a63bf3056"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "920ad5c889e0bd02b9dcf7aa520297c37fff4b14f6a04314b51f16ddcbda9ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92a8ccbb9b00c9e1fc1e2fb632ab628a46cbf84011d82e78c0564c7f88b20290"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
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
