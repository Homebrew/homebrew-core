class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "93cc3b00eb6cd55ac778cefb509845ea0a3c342844ea794022258278089f6b01"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a7ff420812bbe2dd6e3ecc31ffd94fc59fec331f21ce31675093411ddc6898f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22429d266abb059fe18a01ea3d8ede90341d082d42e87eadd4c71cb071faaa7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9808fe3a5938de9b4b34da9cd2586ca02ed670b5db24c61326313ebebe9e7b4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb26ae97f4bd63b7c511f3a773007e746b2bd4ef19f9faabdce2effc124c7db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7bcd445990f5d75bfef2cc93a30900179ff0ceb55aeafddde1505bfc134c76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1903674e830858f727319e5ebc12432426e31aa4a1cab945d1b89a2f57c8938"
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
