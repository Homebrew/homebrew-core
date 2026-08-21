class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0763a96361c4d0c7b6548b0c48b0e3c89b26f2136ba73cf85d570db78496917b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f47f34bfe8e007013325917529dd9e5796895f680c0d642cbc60c51b214df548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8423bbcbade98ae7779bc685e4e4ed3177a0950bdf88b060b87cf6796ac0ed0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "034ccdef1d9eb02cc0b150bc12f0b86f98329690637ec7fa95cf69c447123f43"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed2ed787577555c3aab1ee1863ed99a920d87968101d88718129feb30d6b8897"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38dc3762428f2ccb996bd0ef307f78e077dda08f51c3d104aefa02c13d659c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c98cb1300154d955ba91e55128c7c2379648e15e56c82afb95e6dc3dad98f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
