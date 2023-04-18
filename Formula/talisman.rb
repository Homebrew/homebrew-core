class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "d1cd895f89187d879352a7093679424857cb8809969cbba6437744123e6f5cb3"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e3c58253897f4e796aabb6963fabea461bd4096543bb2a57d55a60292fb986"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23e3c58253897f4e796aabb6963fabea461bd4096543bb2a57d55a60292fb986"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23e3c58253897f4e796aabb6963fabea461bd4096543bb2a57d55a60292fb986"
    sha256 cellar: :any_skip_relocation, ventura:        "e2f69862b62e310f320dbc13c5e0d9f4417aea5cbd8ad1f9e93bf6be12c5e765"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f69862b62e310f320dbc13c5e0d9f4417aea5cbd8ad1f9e93bf6be12c5e765"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2f69862b62e310f320dbc13c5e0d9f4417aea5cbd8ad1f9e93bf6be12c5e765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bec16b3cadc319a9aa2a7c4444764fef035cdc934f8894529a351ddaf880c2a"
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
