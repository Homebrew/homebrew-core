class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "35b1598670e6701021b2622dbc5e05acaba60ced5285b3fdc97b26910fed4bfb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "331d0242afed8925d3c05ede24458de34689fbb50d45107764d7986dd3648b65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b7d2c265450b36ec7fcfccab40228c1a7c5edeb0fc0252be2d86c2d517577f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e666d726788aad08b2f4bc2239facd2fbb8a3e50ab4ba7e7159ba3535655f1fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "09c26b1c79b13a2490dd4d879ecbf991caecc6b8c664a9ea58a879b1bb7c8791"
    sha256 cellar: :any_skip_relocation, ventura:       "53d1e78bb72ffcd53aadb31f29cf16e8498dd33eb1f3e070b62122578cc2f302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe41a753bd41e992ae110e22f50855eb3e5bcdc3f796308bee36fa2efac12a3f"
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
