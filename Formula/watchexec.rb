class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.1.tar.gz"
  sha256 "f3bec95091eef81f3d5e3d185d1ba8743b8145f75848d3f71e4434fe3c2c41a2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdf2eb406c1da69a71b3c6f4e5a0f00cc4eedd5bd6e525e5106308e2a57c4898"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a07ad4b69ce8ec90cb704da9f0eb63dbab02e6823201d6ac5ff4ed3aa9838e03"
    sha256 cellar: :any_skip_relocation, monterey:       "76228ee3d0f479776aff4cf913d7ed9f4f6ac32dcde9c94f45b2272ad09a1bdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9aa1854767bf4dc9d0b68de4b188bb53e5af7f3645ba2a2e61003407f1bd2c44"
    sha256 cellar: :any_skip_relocation, catalina:       "88d98ec9c4444287f06d896290f62370850eba60c5dd234eff53a4e385feaba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce8d61ce787d8f4a3bfcb20370416593194879ab696f929906ee74c8b35a7e65"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
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
