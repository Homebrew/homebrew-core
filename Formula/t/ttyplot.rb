class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://github.com/tenox7/ttyplot/archive/refs/tags/1.7.5.tar.gz"
  sha256 "c60c5fd0606f7413dbd2b9cfb1278568164a9f668cf668eac3c92fb77ecb383c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d001c601d5a11bb2cdcfb9a58add05b3bf4d28df51ff9de842bf47ffe6e688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61dfab4a962a67ffe5a7b7b33b1e9e8c2a47ed96f5eb724a1d133f62ddf476fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02e2259dfd7092c5a28f4750b36b72b9ea8327f851e0311a47ea14fd3317359b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79d1f39e250984e5ca5545c8bacf9f17a51f41538c5b94ce430a607938f758f"
    sha256 cellar: :any,                 arm64_linux:   "54d759ee50c89ed7b6510f54fe8aa5f82ddfcc4eeddb9969f9b8b00242d03161"
    sha256 cellar: :any,                 x86_64_linux:  "7b8ae99d9f466da9e0a127a858c18e10cfcd18267c5a9a7991d45d609fe1e65b"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    assert_match "unit displayed beside vertical bar", shell_output("#{bin}/ttyplot -h")
  end
end
