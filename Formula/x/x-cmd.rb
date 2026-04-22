class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.14.tar.gz"
  sha256 "19b295a0c3c25fe288d65edbea721480b6ba942988840cc18a49b9ddecfec573"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ec39f4fb3020f2ff8d509ce46eb3c173cfc5bf0635c99213f49218fff660124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ec39f4fb3020f2ff8d509ce46eb3c173cfc5bf0635c99213f49218fff660124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ec39f4fb3020f2ff8d509ce46eb3c173cfc5bf0635c99213f49218fff660124"
    sha256 cellar: :any_skip_relocation, sonoma:        "688cc4fd2a55aa5f3a3919b2e7344f6237a0c66bc28390fda7de7fe1158f6809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d533cd2d9f5283ff27eaa7900708dbcf7a4d60ace547524cb9b901c2f858ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d533cd2d9f5283ff27eaa7900708dbcf7a4d60ace547524cb9b901c2f858ae9"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
