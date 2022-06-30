class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.20.3.tar.gz"
  sha256 "ded1a7599a25feef1760a583cb6a21e6a414e34d731ff05f7d014a1ebadcb84c"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f54890b10cb00298f7ff38587e2aac50c8ecce080f5f98d7e9c767772162641"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "563a1463e20b8c6139329d00fbdd0730cd6ac619a73f66b10a048bef534a4acc"
    sha256 cellar: :any_skip_relocation, monterey:       "91dbad2654882e4a90f3ba7cf055788308efad6960b13f26fa518334f1716380"
    sha256 cellar: :any_skip_relocation, big_sur:        "fca56147d4e8431e3420e0e1774349f262efddbe17ceae902b2e0187c3398ca4"
    sha256 cellar: :any_skip_relocation, catalina:       "e7fe9258d1fce651b347675c92a6384b934daf81141eb6e5edd13c4af1cc2256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41a0cf97927e9514d82fd1455ea6c8fa05013243205ac058b8b6af8cc34aeceb"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end
