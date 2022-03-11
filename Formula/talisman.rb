class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.26.0.tar.gz"
  sha256 "e00ef58972bcc103216b6cf9cf980ce94a7078157589bb71645302ccacf5ba25"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26143f107f651cba6f724fe73a8b6bf8a6d727a1e6d836977537e4a05b2afe5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7eaba421e70acdd7b321fab608de434954c00a58b6a25b2774705efbbe5feac"
    sha256 cellar: :any_skip_relocation, monterey:       "02f61d6766dd252a33352f007699cdad4be741167274b40ec26ab88d6ce5c07e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2feff7680aba6ddcd044d633d95aaa356bda7ccc0719f37eaebf4bf715ac4604"
    sha256 cellar: :any_skip_relocation, catalina:       "87a3a909d25a2169614f2f74c40da2afbf1f39924e5f346fb0f85e7256e0ae79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd2f37b7d3e6d51b984e767981472ed41deafe8e1776bdcc15268523937e68f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
