class WormholeWilliam < Formula
  desc "End-to-end encrypted file transfer"
  homepage "https://github.com/psanford/wormhole-william"
  url "https://github.com/psanford/wormhole-william/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "42490f3c7e383d7d410e68a83fc18de1a5e9373934a9d71064e10948197759d1"
  license "MIT"
  head "https://github.com/psanford/wormhole-william.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34739b2a39653c214c26da30f0d05f88ac8dc70b21f2d35d9d9381fea1bb3f14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "842582898b124a66cc3f7881433e1a156a9c92b843984b0e74b94d586600fb71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842582898b124a66cc3f7881433e1a156a9c92b843984b0e74b94d586600fb71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "842582898b124a66cc3f7881433e1a156a9c92b843984b0e74b94d586600fb71"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c3d2757a23dca9a5f86854b325569056e4627163474d405a6b4a3d68b2ac843"
    sha256 cellar: :any_skip_relocation, ventura:       "1c3d2757a23dca9a5f86854b325569056e4627163474d405a6b4a3d68b2ac843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9fc6e936553af437919b8695ddd3e071e38756dea706aea3dc736e1328aac56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "329792c9ade8805ae88177f9c1f47f4fc25d8781df4601a90c3cc17c7957b704"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wormhole-william", "shell-completion")
  end

  test do
    # Send "foo" over the wire
    code = "#{rand(1e12)}-test"
    pid = fork do
      exec bin/"wormhole-william", "send", "--code", code, "--text", "foo"
    end

    # Give it some time
    sleep 2

    # Receive the text back
    assert_match "foo\n", shell_output("#{bin}/wormhole-william receive #{code}")
  ensure
    Process.wait(pid)
  end
end
