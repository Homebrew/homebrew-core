class Signmykey < Formula
  desc "Automated SSH Certificate Authority"
  homepage "https://signmykey.io/"
  url "https://github.com/signmykeyio/signmykey/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "3d08c9b0fbe6c6bcd8240ff0a65121ace0413f30abdd40068930509abc84e4ba"
  license "MIT"
  head "https://github.com/signmykeyio/signmykey.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13f42dcc050c7a1c8f4284603c2b9cf51fc0fdfeec5a59a9c6cc7973fe4a4b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13f42dcc050c7a1c8f4284603c2b9cf51fc0fdfeec5a59a9c6cc7973fe4a4b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13f42dcc050c7a1c8f4284603c2b9cf51fc0fdfeec5a59a9c6cc7973fe4a4b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7f9f2972ad442c06ad29a0102bc6a40ba0f9321d90c8cc2f02ea3665d4e71fd"
    sha256 cellar: :any_skip_relocation, ventura:       "a7f9f2972ad442c06ad29a0102bc6a40ba0f9321d90c8cc2f02ea3665d4e71fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d80a2c91ff6d9fa7e8d95b5a05c7e072380c8fc10e167ee0fd6dc68faeb4aaa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/signmykeyio/signmykey/cmd.versionString=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"signmykey", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/signmykey version")

    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/signmykey server dev -u myremoteuser")
    sleep 2
    assert_match "Starting signmykey server in DEV mode", stdout.readline
  end
end
