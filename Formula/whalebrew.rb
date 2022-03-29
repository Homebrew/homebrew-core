class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
      tag:      "0.4.0",
      revision: "1722002db3f1618f7af9d400343bf502d03b508f"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adc2032cb648b90f43903e425a4f117b104a65bbe31259cd3e6099f5ca895adf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8124f6c257d211ad2ea6f26fd1803efe6408ea7c91e12b8e2f75f7c993feba31"
    sha256 cellar: :any_skip_relocation, monterey:       "21e0746c7700f2e3755d99ee64f85c89767dc611a5280dee81f8e58b60dfcc80"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ba0c1e96cb7b482e7053e897c2ed50a22fffded6e939d552237b6c54f7f612f"
    sha256 cellar: :any_skip_relocation, catalina:       "f18d17d362d27dd2fe1df05591c679653395e0a56e39cec148770b5f89011b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c4059b725199ee59d80e73f44502223d32dcee3d457c8fd8b86764ca6139ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
