class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.6.9.tar.gz"
  sha256 "96117167845c00808332ad770ea5eba8859b13d947f925ff93af2cd4026288c2"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d0f9ceca80f51543ac919b005721543e320b25b444137807000c8b11d0f8a71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4465230889da16cb602026a5b2ea27a2fed1b093e1384964c42813defb68bb0f"
    sha256 cellar: :any_skip_relocation, monterey:       "586b9c29ab643138d68c4fd2feaa0909bd0d88515652163aa203c132f812aebc"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ff8d1acfc95b5a7e45f4efc0e62d1ce018934e7d92735b1f82ddf6fabefcfef"
    sha256 cellar: :any_skip_relocation, catalina:       "617ca8d663d7ad47003d91d5e42dca1eb65919c2ae85b5b733aaeeaae665afd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a47416aa1633362ba63a66b2794bc87c4eea022c70bf9f35ca7774497dbb61d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
