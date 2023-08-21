class Uncover < Formula
  desc "Tool to discover exposed hosts on the internet using multiple search engines"
  homepage "https://github.com/projectdiscovery/uncover"
  url "https://github.com/projectdiscovery/uncover/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "fba6859bbf30c1175b2ff4a9978af9571494564cc3da050151773ad5f95769de"
  license "MIT"
  head "https://github.com/projectdiscovery/uncover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9331531ccb753717882646863b715b22eba96fde9314cf3c24cfb2eb3340b076"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9331531ccb753717882646863b715b22eba96fde9314cf3c24cfb2eb3340b076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9331531ccb753717882646863b715b22eba96fde9314cf3c24cfb2eb3340b076"
    sha256 cellar: :any_skip_relocation, ventura:        "5aeb9ef1ef9adad4021391c065185329c2da1fe695cb5477c9057b4eae7c86a7"
    sha256 cellar: :any_skip_relocation, monterey:       "5aeb9ef1ef9adad4021391c065185329c2da1fe695cb5477c9057b4eae7c86a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aeb9ef1ef9adad4021391c065185329c2da1fe695cb5477c9057b4eae7c86a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82908efc13b1cf3b6d233c184a7829492ffdd426a18463e37e1c4338cb8a66e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/uncover"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uncover -version 2>&1")
    assert_match "no keys were found", shell_output("#{bin}/uncover -q brew -e shodan 2>&1", 1)
  end
end
