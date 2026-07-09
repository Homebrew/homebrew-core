class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and daemon runtime"
  homepage "https://rmux.io"
  url "https://static.crates.io/crates/rmux/rmux-0.8.0.crate"
  sha256 "f6fe70b80deab4c6566e5be5f2d492fe5c5123168ed2655961e787cf2c33c354"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e935166d6adb604bd4ac477eb7ac4ecd4cf4e71620845596633fd6447aeddfdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a86d57443f3052113d6d02d4d25d0ea9499da290ac8cfc6211dbf2fa1be57b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eff130f9e2fa78a2968c9588c3f13150de9da676635bd6a93da53533b986eed"
    sha256 cellar: :any_skip_relocation, sonoma:        "12c300430af628410ee1baba14a5fbadb717fd6afbd4327ee84151cc6081d6cf"
    sha256 cellar: :any,                 arm64_linux:   "d855520bfb70273ea3da82c44da62ebaad2d754dec3e147c536358b41303968b"
    sha256 cellar: :any,                 x86_64_linux:  "672f84073cb9f25031ef232d16368538204476051a19430f7b7e157467f44d98"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/man/rmux.1"
  end

  test do
    require "json"

    assert_match "rmux #{version}", shell_output("#{bin}/rmux -V")
    diagnostics = JSON.parse(shell_output("#{bin}/rmux diagnose --json"))
    assert_equal version.to_s, diagnostics.fetch("version")
  end
end
