class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.6.tar.gz"
  sha256 "e5c8f98f3048cccc3f8e49c0449435a839a18c7f12426643ac80731b63b829a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8fb7acbcb922af01da7e97b7c3ef303dcda92762996d2ad9a12ffec1bfea608" => :mojave
    sha256 "4a5566659aedb0453c68c468c65521b53d0602113a940b50afab759488b4997c" => :high_sierra
    sha256 "80ed662db0f0e057a2346e25244b52fd3019fdb6f1af1e809b03392a82d0dcd9" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/vektorlab/slackcat"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"slackcat", "-ldflags", "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
