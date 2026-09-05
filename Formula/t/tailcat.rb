class Tailcat < Formula
  desc "Netcat-like tool over Tailscale's data plane, without its control plane"
  homepage "https://github.com/tailscale/tailcat"
  url "https://github.com/tailscale/tailcat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "14d0e1a80dd4836053dd3e2cd6bbb1ad40ecf72c181c3f92d319d325bf7f6e6f"
  license "BSD-3-Clause"
  head "https://github.com/tailscale/tailcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f686d22d495a8ee91bc1af7f908500af276851aaf7913a8a99c5993974d429b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e132bd00487bca6a37dd8c500a5343b4febe7663b5063d89eaf348fffd23179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f91c1798eb7e91de6ea3cdea482c467e4810f607393af82080d743461228a345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a913305bf974b4cc867189a6f6a3f33d792f5f990a4be06a6ba4a78c36b43df"
    sha256 cellar: :any,                 x86_64_linux:  "1d2ff46c7d8d17f801c5517631a1779d85981a872ffa56db56d43282addd384e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/tailcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tailcat --version")

    derpmap_url = "--derpmap-url=none" # ensure no external network access
    addr_file = testpath/"addr"
    server_stdout = testpath/"server_stdout"
    server_log = testpath/"server_log"
    payload = "hello from homebrew"

    server_pid = fork do
      ENV["TS_DEBUG_TAILCAT_LOCAL_DERP"] = "1"
      ENV["TAILCAT_ADDR_FILE"] = addr_file.to_s
      exec bin/"tailcat", "--key=new", derpmap_url,
           out: server_stdout.to_s, err: server_log.to_s
    end

    blob = nil
    60.times do
      blob = addr_file.read.chomp if addr_file.exist?
      break unless blob.to_s.empty?

      sleep 0.5
    end
    refute_empty blob.to_s, "timed out waiting for the server address"

    pipe_output("#{bin}/tailcat --key=new #{derpmap_url} #{blob}", payload, 0)

    Process.wait(server_pid)
    assert_predicate $CHILD_STATUS, :success?, "server exited #{$CHILD_STATUS}: #{server_log.read}"
    assert_equal payload, server_stdout.read
  end
end
