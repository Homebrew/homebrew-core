class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.28.1.tar.gz"
  sha256 "687fc7861820cb62c847cff53b27845af13cbd445bc6ddfbdc612037e8fcde0d"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a9b9c25d4e294a5d7d90a5c6219b40ce1e5fc15b9860bb679bdb88583d16a8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39e95ddab700a6104c5c4baf012ab3fba3c5c938cdf2b7e8b295c914412cf365"
    sha256 cellar: :any_skip_relocation, monterey:       "2738cb7eb9a3d443365111ebd0ed32124fc37972e2f98c9f3871d44dc89b230b"
    sha256 cellar: :any_skip_relocation, big_sur:        "58fddb3e42a9e4ffc84e44fc02f8f81c4bb18ada98299877a193e4844d2aa9ac"
    sha256 cellar: :any_skip_relocation, catalina:       "855b69fa68de0246e9478cf0d348600735ff70e70779891979335a9643680be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03b0989c5dbe7ac264b57e8af40eb9bca063a9d4f70c7e3d7f42a9f48bca813f"
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
