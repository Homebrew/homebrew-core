class SessionManagerPlugin < Formula
  desc "Plugin for AWS CLI to start and end sessions that connect to managed instances"
  homepage "https://github.com/aws/session-manager-plugin"
  url "https://github.com/aws/session-manager-plugin/archive/refs/tags/1.2.279.0.tar.gz"
  sha256 "8f14d12aa528d27ba787b20e7ea8492e07cc80321de51843ecd44436dcd64dc1"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "session-manager-plugin"
    bin.install "session-manager-plugin"
  end
end
