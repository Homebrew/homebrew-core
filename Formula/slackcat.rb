class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.4.tar.gz"
  sha256 "43c80b7d546bca51af47b3df8b79a2e5ce021042ea91d877e2feb33a7ca81305"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6b46f20293da99226fdeb610dc78780cc3b6e8ec66390d982a5b08f574aed3b5" => :mojave
    sha256 "81bf29fac1f47bfaa4064b9b03aae96c4ea179158b0baeb0868203c6b7144221" => :high_sierra
    sha256 "7a0331e03695488f07eba24c4ebef11b406face8dcdbfc632beb8c5eb3227395" => :sierra
    sha256 "bd75f396807917734adec3c541faebee3789841474fdd81c343c61c6a739d293" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/vektorlab/slackcat").install buildpath.children
    cd "src/github.com/vektorlab/slackcat" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"slackcat",
           "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
