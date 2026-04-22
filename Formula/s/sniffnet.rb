class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://sniffnet.net/"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "c2000ee833c8329d5aaf2b4c1f950d01b48b2a93bd094f949dbed5d6ac4f4d8c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb270fc29006b2715f9349ebb56be995c87882077445f116e112fbb124df4b8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f1550377e32b24139576e6bf66bf4ee8499ac0003b7d8994bf25a3a99bb0e37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "680474f087bac2d927c28983cecfa659662c82785f127f40781b50c3575cc01b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d474bd3b1d41fd98cf764cc0ad1caf194d9122314d873505d79d53267cb9066f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "417d26b7b402396152a20d5d38cd97133e16942b5cc46019d14d2dc59e2ac6d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37d1b708f7922f7399d952d2b5282e96e1bb8fcc5e8b3e1b949d055ad0fd5bb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # sniffet is a GUI application
    pid = spawn bin/"sniffnet"
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
