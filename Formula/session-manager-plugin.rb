class SessionManagerPlugin < Formula
  version "1.2.279.0"
  sha256 "8f14d12aa528d27ba787b20e7ea8492e07cc80321de51843ecd44436dcd64dc1"

  desc "Plugin for AWS CLI to start and end sessions that connect to managed instances"
  url "https://s3.amazonaws.com/session-manager-downloads/plugin/#{version}/mac/session-manager-plugin.pkg",
      verified: "s3.amazonaws.com/session-manager-downloads/"
  license "Apache-2.0"
  homepage "https://github.com/aws/session-manager-plugin"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "session-manager-plugin"
    bin.install "session-manager-plugin"
  end
end
