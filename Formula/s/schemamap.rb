class Schemamap < Formula
  desc "Instant batch data import for Postgres"
  homepage "https://github.com/schemamap/schemamap"
  url "https://github.com/schemamap/schemamap/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "422293dcd81f8f167622f90309282f36d3ddeb4e6ece7ecd8b4cd3abb97c4fe9"
  license "MIT"
  head "https://github.com/schemamap/schemamap.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    cd "rust" do
      system "cargo", "install", *std_cargo_args
    end
  end

  service do
    run [opt_bin/"schemamap", "up", "-f", "#{etc}/schemamap/schemamap-tunnel.toml"]
    keep_alive true
    log_path var/"log/schemamap.log"
    error_log_path var/"log/schemamap.log"
  end

  test do
    output = shell_output("#{bin}/schemamap init --dbname=postgres --dry-run")
    assert_match "create schema if not exists schemamap;", output

    assert_match version.to_s, shell_output("#{bin}/schemamap --version")
  end
end
