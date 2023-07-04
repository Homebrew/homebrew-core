class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.7.0.tar.gz"
  sha256 "397e5b3d5476fbed6ddd507b0213361fca6ef8c27e72c21ff1d8bb0d794a4d8c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3f0167dfe72036053015c82e4449f33d6489559b0224bd490049027326b74b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0432aad69d73e8f5ef6923ad7d7d6f62be7d5461ae55da18922bcd668af6a866"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "090f2b1a7cd88585e35f840b34c57e8e46e155101b2bcdf35938ccb8b7112b09"
    sha256 cellar: :any_skip_relocation, ventura:        "206bac07e7ba0ea2fe81bcdda9ae2bef10cc21917766a4d331ebbd0188389505"
    sha256 cellar: :any_skip_relocation, monterey:       "58dcec98b5d72e9941e2bb78106cf4be46851dd04311a926c208b9f78b8cc6ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1a370e4b6155a0b9176d030f213bab4f646b2285e537e81ab1f350c8222ce08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ff116518a3bc08cc5baab28e0fecb7c50f2c1567c3a4ba4dc5ecc9d1a8a7a13"
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
