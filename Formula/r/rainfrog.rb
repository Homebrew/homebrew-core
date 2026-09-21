class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "93e4c2fb0bd1aab0caf2eba25de9bff90aa56356d24c814f5c58871d7d4112ab"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6cabda834cb381f26e53d0d442a1cd2c7df9174b4aa1b2f545ce09fdc980e03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6395720824b4049ffbd0341d896d0a4229efb39ea4666f8130afafe6ce31972"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d167b8601d34ea2e86ec735fd10e06190e5396765556d055d09c826e619da58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3b23163e3500f6c1578941fe69c1fb319d3298963a50e9284bb08d0270e48c53"
    sha256 cellar: :any_skip_relocation, sonoma:            "1522d478be2d3dbbd924c43a38e6c7c11dabaade127bca3c7fba6ed884f6a23f"
    sha256 cellar: :any,                 arm64_linux:       "c6bfa6d5eb6f9ddbcb5c8f7a9025221051e229ff8d2f62677042972cb59cf12f"
    sha256 cellar: :any,                 x86_64_linux:      "77aac98ccf8712f40a101bd1675a706b82cbabe5fce830aaa2d5ee9de08cbe0f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
