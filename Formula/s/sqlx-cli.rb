class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "48eaacc9a800af48c35713d300bc0de0c1e04b84c810b25de1007806fa1d718c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6905b7820d20f88b03711327e7e59993617712ccb58c4830d8001287920ed30f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c1071d2d59a75b0bd8400e573e97b6feb386d828753ccc7bd1ee091237114de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c0d09f42e2219e0b8fcc1773b0fffaa7e54f11a7acf70459a3d7a8a794b1350"
    sha256 cellar: :any_skip_relocation, sonoma:        "2007fb6ba0a9ed1022a5da2e5d047f2a5c16dc2cf3ee8d9524ef083c7299757b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30bcecee4ef0036459fb2c26c0aa200d35ad13662fec6332fb95aad37931d426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b505c3d6f5b2815c2507087836eeaf1f8d2e1e4f674ef66f8b434c0db7ff9a30"
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
    assert_match version.to_s, shell_output("#{bin}/sqlx --version")

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    output = shell_output("#{bin}/sqlx migrate info 2>&1", 1)
    assert_match "error: while resolving migrations: error canonicalizing path migrations", output
  end
end
