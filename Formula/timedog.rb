class Timedog < Formula
  desc "Lists files that were saved by a backup of the macOS Time Machine"
  homepage "https://github.com/nlfiedler/timedog"
  url "https://github.com/nlfiedler/timedog/archive/v1.4.tar.gz"
  sha256 "169ab408fe5c6b292a7d4adf0845c42160108fd43d6a392b95210204de49cb52"
  license "GPL-2.0"
  head "https://github.com/nlfiedler/timedog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0fa4a5e282aa24e8c97c2b522a32f3182b6c6b6d83da1dd5590fe9f31b9215c"
  end

  depends_on :macos

  def install
    bin.install "timedog"
  end

  test do
    assert_match "No machine directory found for host", shell_output("#{bin}/timedog 2>&1", 1)
  end
end
