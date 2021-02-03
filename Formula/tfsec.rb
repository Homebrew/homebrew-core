class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.37.1.tar.gz"
  sha256 "b05a70b267f055619c5950ed8d6c49310b5851b352739ef651bc34c3468d1c2d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08dcc753a822be95c875e8ff72b97b19da983107cc6d452bd7f421702ee46740"
    sha256 cellar: :any_skip_relocation, big_sur:       "d92c146999c766e93446e6ac6547deab4620d0a3e06b7da798e38abd1df9ee18"
    sha256 cellar: :any_skip_relocation, catalina:      "58b35ac931d88b4d1ae04424ecbf1377ff414d5b03580a4e370e32d9bfe37241"
    sha256 cellar: :any_skip_relocation, mojave:        "c752c13c831aee61e8f224cb4d275d63b386fe34f479b9ba0cf234fff72d3649"
  end

  depends_on "go" => :build

  resource "testfile" do
    url "https://raw.githubusercontent.com/tfsec/tfsec/2d9b76a/example/brew-validate.tf"
    sha256 "3ef5c46e81e9f0b42578fd8ddce959145cd043f87fd621a12140e99681f1128a"
  end

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    resource("testfile").stage do
      assert_match "No problems detected!", shell_output("#{bin}/tfsec .")
    end
  end
end
