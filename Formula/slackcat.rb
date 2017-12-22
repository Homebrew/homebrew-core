class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.4.tar.gz"
  sha256 "43c80b7d546bca51af47b3df8b79a2e5ce021042ea91d877e2feb33a7ca81305"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1bcaa0c2b10cb857978689be04d2a75865ea353259a5531a3da124fdf239eac" => :high_sierra
    sha256 "ba66b3b7c0d0376edf14e8b951026bd79b8d2f52cd8d3826ce4a1fc3b11d7004" => :sierra
    sha256 "b97794811a471a2cd1cb0ef9cd0045b2e2b68502c7c979239eda0b1ec56c9db3" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/vektorlab/slackcat").install buildpath.children
    cd "src/github.com/vektorlab/slackcat" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"slackcat",
           "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
