class TftpNow < Formula
  desc "Single-binary TFTP server and client that you can use right now"
  homepage "https://github.com/puhitaku/tftp-now"
  url "https://github.com/puhitaku/tftp-now/archive/refs/tags/1.2.0.tar.gz"
  sha256 "428c9ef7336644e748c280277495e3ec724f0c0c38f3724de5f1e4c42d8431c6"
  license "MIT"
  head "https://github.com/puhitaku/tftp-now.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ce9f2e42db06397ce68aece55bf85848ea8a08f253aafd0c0c2429435dc75e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ce9f2e42db06397ce68aece55bf85848ea8a08f253aafd0c0c2429435dc75e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ce9f2e42db06397ce68aece55bf85848ea8a08f253aafd0c0c2429435dc75e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "947f3f23f70ba7d0d6d60b0c3202c3d5c2126c210fdd55e352d1b7ce04b09aa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2a31bc87475ead93fbc73ea37eb25898209a46d51a1caf345698154b5420b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec7f9c6bb08da996dd10a5cbb1a098eff0b0d1e7d3987083fd3e6e8a77ceefd0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "netgo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tftp-now help", 1)

    port = free_port
    pid = fork { exec bin/"tftp-now", "serve", "-port", port.to_s, "-root", testpath }
    sleep 1
    (testpath/"testfile").write "Hello, world!"

    output = pipe_output("#{bin}/tftp-now read -host 127.0.0.1 " \
                         "-port #{port} -local - -remote testfile", (testpath/"testfile").read)
    output = output.gsub(/\e\[\d+(;\d+)?m/, "")
    assert_match "start reading blocksize=512 host=127.0.0.1:#{port} local=- remote=testfile", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
