class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e99dfbdce5a5b5c051dbaec49351e475ebd89a121534e91291b9907dcae57de2"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c9941c4c1cfe9b56f983c7855d64d25ccc18a61a6393691ad80a0cf8bea7706"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef5e3a4b2f9af002ca82fbc3288beeb0c5aeefb76bfd90218ee8af6cb08d15e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2911bf761fb167e8cd99dc84958efc57b5a066d8f8298a549e85c2ee4afa134"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdfbdc8812f8fe5d1206fa886471a2cda8bf84878b71085268876bc941ba38da"
    sha256 cellar: :any_skip_relocation, ventura:       "2a7cf8856aef971e88ca90cf2b6c5064a4db9cc70c2b26a8d3fa7729d025432f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef1a89098e12b2a3fae9de5b81d967c083b569ad5f94b7019a6fbc2d9465614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ae43dac0ab007e568387ab83ee0319743ffbd4efd2af3a6d5b09fbc9d1f5f34"
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
