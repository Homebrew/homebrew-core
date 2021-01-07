class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v1.6.tar.gz"
  sha256 "e5c8f98f3048cccc3f8e49c0449435a839a18c7f12426643ac80731b63b829a9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e85154adefee83a744499a3245f7d8ba17bcdd4c440682981c51cea1418a2547" => :big_sur
    sha256 "4ba0783aa565e830fee1069392b51edacc64fb9c5df7964f494f268930dc9483" => :arm64_big_sur
    sha256 "31ab32e1c07a54dd6e06900a990f2e4b82295273155f25332596c17671d33b9f" => :catalina
    sha256 "b8fb7acbcb922af01da7e97b7c3ef303dcda92762996d2ad9a12ffec1bfea608" => :mojave
    sha256 "4a5566659aedb0453c68c468c65521b53d0602113a940b50afab759488b4997c" => :high_sierra
    sha256 "80ed662db0f0e057a2346e25244b52fd3019fdb6f1af1e809b03392a82d0dcd9" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
