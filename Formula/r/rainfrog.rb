class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "a38f4d1bed46ee4c81a36cec0c8999532c7f8900717b87b7f5bd5b02a93defd8"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b355b6f5747bb6647ced62235a8144fc2e0540c3e640e65ca53b0d059b71135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be16e4907ea97d0da10828fa3d436c5c386e809ac467f81f08c3ffaae16d2da8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5533303c785129ff95aa8d0cd0529ff20551de2f3cc3896a5cd10f34a3ef24"
    sha256 cellar: :any_skip_relocation, sonoma:        "4739e6130b69987a37fcf2f27fd75eac386eaa90fc5d32f98fe4a19add1d9c75"
    sha256 cellar: :any,                 arm64_linux:   "72b0e1bba48986fb5cd27740c138398b31d8f5c27bbb526be1f75a87bb0589ec"
    sha256 cellar: :any,                 x86_64_linux:  "e89414b5f289066497fc711f25503b81b9ba2d5739df51d5a80f4d525a00da2e"
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
