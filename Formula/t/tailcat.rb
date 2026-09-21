class Tailcat < Formula
  desc "Netcat-like tool over Tailscale's data plane, without its control plane"
  homepage "https://github.com/tailscale/tailcat"
  url "https://github.com/tailscale/tailcat/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "54a97d9046d0bf2afbf99987ff630fc425ee79272c6c7ccd645a49a076d3cecb"
  license "BSD-3-Clause"
  head "https://github.com/tailscale/tailcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b9a79a9c847a94c7ac4544ef8b975db39fcc5db94dc9285b9a15ae24e52e6d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cfd5f77dfda9a3fc6e66ec60a0d408527281d61f47cf06680fea0c28ffe5f212"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ad12dbe1687b64f6eb990a71dc111f6d33c0aebff1e342a8ae6c209412f6769"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "313ccd5f792b7ee23fc88d352fd09fb801bac0bed8b6dc03d4b1735fca83031b"
    sha256 cellar: :any,                 x86_64_linux:      "3d20bb3caa436e21d7f13eab763919b36b948917e411af52342b8cbcbedbb19a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
