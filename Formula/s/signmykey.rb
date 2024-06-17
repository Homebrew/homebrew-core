class Signmykey < Formula
  desc "Automated SSH Certificate Authority"
  homepage "https://signmykey.io"
  url "https://github.com/signmykeyio/signmykey/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "16c34d874bf6cec0d83dbefb8dea0b89afacd0884a1069e2d9f5ee8b499133ed"
  license "MIT"
  head "https://github.com/signmykeyio/signmykey.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c735b4c74571749c949743f4a5f1e72a530ed9a252f4c6f982784da3e8166eff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ac2184b3bb728bac7fa17b4365f9ddc2b06a6b61ae51e85164a969521ef06a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13175251cc1356a649398221b2e1ca7dd6c72215da73d4b788fcd07f3ad1933d"
    sha256 cellar: :any_skip_relocation, sonoma:         "779cd8f7ab0de371ab01bae5e19b49890a17d53b2ac5cc1fd0ff6c4bdd242d35"
    sha256 cellar: :any_skip_relocation, ventura:        "86a393be6f86a79b85fc5d7dfa2419a358312ba3472b3c23994bca6d275eebd4"
    sha256 cellar: :any_skip_relocation, monterey:       "d3493a9c55a59a0843e8b7c4fed154e6148cf44aa7127dd760d9fc41a4802fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa5da62b6a04f5f054906020b219c25551872a5003480d36c0a0342e81c8cf63"
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
