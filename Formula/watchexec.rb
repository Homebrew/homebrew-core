class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.9.tar.gz"
  sha256 "7f6d8339635870ff9e07648b1512c1e8cf7d4dcd52a3ee98f78ceab13594c3a2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd77971254147bb19f839b95f99fbd268d7c26a75ba7b65e5a7a72e0604eff86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e33a9bfc9cfba66bf136b6dd41b790d7c1566a0772fed3e0834707e831a9251"
    sha256 cellar: :any_skip_relocation, monterey:       "c782e1eb97954b2d70f0d87b91da5235dad9a85fce84d8d5b94a06cf6bed2f25"
    sha256 cellar: :any_skip_relocation, big_sur:        "780f2b1d739c7e41ec40fe1acaca89fcf8f6cf3c281ffa3a15c6c01acec4a90b"
    sha256 cellar: :any_skip_relocation, catalina:       "4ca360c475e7cb860e27ff3b071fe177f039d0990e65331262ff32c0cc7a2223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b95d5c30b5d0121cdeeb3403cc695273ceef9dd2d792a7034a1517568b3dfe5"
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
