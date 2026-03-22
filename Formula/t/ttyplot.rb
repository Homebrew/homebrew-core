class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://github.com/tenox7/ttyplot/archive/refs/tags/1.7.1.tar.gz"
  sha256 "d1624eea52abec5538c9b19bae00f81642c2d2886cd7755988466b74424ce9ca"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "816129fa92f1f7570a96c8ef72b50739cdf8b61aa1e82757b39ef9c7167743b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f2f451e768d21221e8ac31f5d6cfcac856315052a16bd213c5410166de3eb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5b767fb22376073b1cba6e278d070248b8c8dd5823559360b36386218eed7f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39a3bd658a12d3eb8be9baa5ab23b4bc85c2cfacb96fd05aac64b8dfae705702"
    sha256 cellar: :any_skip_relocation, sonoma:        "a15fda21cf564d3fc84ec3930879758b07d6d462c08c086fab150957d56593e8"
    sha256 cellar: :any_skip_relocation, ventura:       "e2aad133932bcf084b6cfae316e8ff6bd1cdc51b449cbb0a918365bfd9ae1788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9477520982405b4c6dcc165fefbf076da0774c10cf32e0423b4be6f88cb45742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1a52187d8e41064b9d3e9d6a6c452fdb03e989591ee0d05a2d4829280579e3"
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
