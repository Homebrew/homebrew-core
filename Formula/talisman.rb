class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.11.0.tar.gz"
  sha256 "95ebb3ac0215bf43d6cdf17d320e22601a3a7228d979e5a6cbaf8c4082f9ad22"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29b3e7899c9ce3670117f8103e32dc16a33f31226cec659090615077ff0c7972"
    sha256 cellar: :any_skip_relocation, big_sur:       "57933ab62f37660df966e3432537f0e5c42697144c529f876778ab3e1c425dba"
    sha256 cellar: :any_skip_relocation, catalina:      "aee578e215a399179809dcf213cfd3042f92bca8f36249c45b0bdb9897088ec4"
    sha256 cellar: :any_skip_relocation, mojave:        "ac3b724c68357ff3768d700c40fcaf517e81ece52b1da31cd6c897d4362f2940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9570ec86eb5d2a3dffd5aa6e4d64a7cb49eb940e14bd5b53f4671080c0d996"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
