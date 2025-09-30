class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "7e6457c9041b2b28bd77324e76210bf1ff8f23b58ff6980d9bccc142286af091"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "024b4a67c5dbf7a760934888b55c516aa4d05d00f183abd164870f97a1b350f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "740cb40958737089e2425bfe8c73d6d2a2c258dd1e862a5a9850f2d6e41da32e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8acfbb6f3010a81aa4e8c8f8091d3bc00317bd206de0a66ebe3dd8d171d7049"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9424094bf9e97974961281371ce50f49dc8915eacc3ae66aec53e1fc681ae3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "634c3cabba4b9cec73f7e82c946eb9a62312d4d39d4c9c4e9d62d0de1faa3e96"
    sha256 cellar: :any_skip_relocation, ventura:       "d0e042608571badad3193ea199d393e76fd52b3d5193db90e29ced364952d921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "244405f4006ea795038e380519ebca5672f9fc02724a7e6af727ae0eef397d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37dca61cf2d7820264bacecb86fb52faeeeec69b68ef6c5b69670604313714a4"
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
