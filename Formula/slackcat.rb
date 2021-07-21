class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/bcicen/slackcat/archive/refs/tags/1.7.3.tar.gz"
  sha256 "2e3ed7ad5ab3075a8e80a6a0b08a8c52bb8e6e39f6ab03597f456278bfa7768b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4afbc9b42ef6eff3b63598a4c241d16ab5673912139b39e259b521d8ff40fd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffd89b1f8ec05ad9258fbed8b8e1a2f11345414de7d160cbf11250887a4b037b"
    sha256 cellar: :any_skip_relocation, catalina:      "ca236771d46645d91e47f6b907fd2171822f6f7d0ca79e5c086366c73b5e57c7"
    sha256 cellar: :any_skip_relocation, mojave:        "874dfe7ec201371aa7f8b5e011db03cf573c63c893ecb7f851eabd839c144a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a87844885f173328dbc2d739a929e4ce89d72125770a5b776ac79ffb3d5b437"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
