class SessionManagerPlugin < Formula
  desc "Plugin for AWS CLI to start and end sessions that connect to managed instances"
  homepage "https://github.com/aws/session-manager-plugin"
  url "https://github.com/aws/session-manager-plugin/archive/refs/tags/1.2.279.0.tar.gz"
  license "Apache-2.0"
  sha256 "50ea46e00063d21cfa87ecfc95f03055acb86587ac006bad165541290b8da875"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    # open source, but the code base does not compile
    # gofmt -w src && go mod init || true && go mod vendor && make clean release
    system "gofmt", "-w", "src/"
    system "make", "release"
    # system "go", "build", "-o", "session-manager-plugin"
    # bin.install "session-manager-plugin"
  end

  test do
    system bin/"session-manager-plugin"
  end
end
