class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "bc5aa6a366433531885fc6b730c8f6b03e405792bff54ca0e9168891b6d9f589"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e01b7a702363c34e11aabd4b0f5ec1c7b69d2eb4c1820c52f4e4cd7c23eba00d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64ed2b933dcf4559b6fce73335359ed42ed9350e1a5ff7e9a67d571bd809656d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "224b0e56e8572e8c647fcecbfb5337c8de1059203be9eccde0c2ea63a7f8bf61"
    sha256 cellar: :any_skip_relocation, sonoma:        "983d09b1eb5d42a5ed2a5d74985d9776bada033fa3dd0750f4d7af41ccc74a2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ea51f267273d3db5a2a85a46d19a2c9593820fbb88ca445a6e62327301aae6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a5c526f37faefd7839302f5668972e7419ff279a6433503a92ebe53adb443a"
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
