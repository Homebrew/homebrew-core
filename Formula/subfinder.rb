class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.4.9.tar.gz"
  sha256 "0163626e69aa4ea4642633ab447ca2afcf2e06f7aec16c2aa95ec5ce301250cf"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2116f221af97bf51db37c86020f027ed9aaf8b2c73410859d6746779e8c9e80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "275f012045f782e5097a506b112e3c09b81c87a93259705d0ea13e41585a1704"
    sha256 cellar: :any_skip_relocation, monterey:       "e709497a74455408d0bf5daecb8d6058698e36c7db8406241587d635a5560670"
    sha256 cellar: :any_skip_relocation, big_sur:        "77319ca3d1d8360938b24c81487c301205070ce81d7fda7f75b957b633bbff86"
    sha256 cellar: :any_skip_relocation, catalina:       "0e8874bad100d4d2cfa29de2498fe991508f4f67545e72a39e0edd1075344a96"
    sha256 cellar: :any_skip_relocation, mojave:         "6d9d8773ef562f6852bbec33cba7b40f4e73fa33b814dd6e40562140e6e0dd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7dade6ab43d55abf77ad24a09da38b0d1d0f47cd74b93d665eeb3689a3cba31"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
