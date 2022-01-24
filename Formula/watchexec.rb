class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.2.tar.gz"
  sha256 "e74d20c42537f4c4eaa80785613d2abfd383010afcf09064cb65d70a267d0d6e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a696411563fcb6faf7b2331cc8bfb7ec916783a3ea6e959b73a16d923133f706"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bbd0523bf7300648d3a1c4686e2448985bae8fc3f3f6846223a688d64a07b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "cea69cd7da16bd97f53e84fee904c7006fd7eaeaef1ff70af83c15f9df398ada"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5795941fa0e7c55102c14326ac9fca984b7be33e1ff527614d7a45d7e7790ec"
    sha256 cellar: :any_skip_relocation, catalina:       "af3822d0e19c62b36d8586d7bdff1ac2f23d44bcecb1d2941cbb9baaffce0b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f743da8aafa0bdfd84a8b80f966189ca5c99e7750847bf3e8bdd2d351818f01"
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
