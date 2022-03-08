class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.25.0.tar.gz"
  sha256 "e3ff0ce7b55cf61e0eef889324b7d50f9d8691138990fc7792dde6ce246627f0"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea4952bced60c28f401c03f7cd47d7f9c58f719ee5c4e96776602533bee1a8f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d80848a9639a4fa368c126770c8f9f4f2db24d6f0a968acfeef2f5e5a2ef515"
    sha256 cellar: :any_skip_relocation, monterey:       "bfafb27238557da2537a13380b9a80004e190ca4bb840443768456669978621c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f786a38009d08c0296cf1608bfa556b03ca2790d8d8c8399039a4e88dbbe33d5"
    sha256 cellar: :any_skip_relocation, catalina:       "dccd44ab7e17e7f82841825f21f49411ce6e60f04329583031e286fe2b09486f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c45166f1f677019a8f7b167fb7b6bcf90739f34c63143abee2abb07ad58b2fb1"
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
