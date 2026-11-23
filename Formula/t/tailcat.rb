class Tailcat < Formula
  desc "Netcat-like tool over Tailscale's data plane, without its control plane"
  homepage "https://github.com/tailscale/tailcat"
  url "https://github.com/tailscale/tailcat/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4bcf86535445f1160f29958dbce57fda54bb203ffb89e5a153b6ecc933e91814"
  license "BSD-3-Clause"
  head "https://github.com/tailscale/tailcat.git", branch: "main"

  bottle do
    manifest_sha256 "c39040b2407542b462d694ba3170726680699a68b0c60816ad1984bc1027260f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2d4af4f6cb1134222019c885b30db4820faecceff297565d92aff9af59a6d2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc196387cb6a0e34ddc5d74e0fa2050e1c68d8752c48c2a372ecb3c94474501c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab0fe8d21e26d88d11193fe854b712e0970aa9c016fcecfb5bb707285b4ff3e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd7474caddb6615e0f3a2f914a31a9978c76e33b713566fc5e65adfcfda7f011"
    sha256 cellar: :any,                 x86_64_linux:      "082b3a59eda197987b5a0de492f75f2c40141d7df77c902c68e62c7369efc484"
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
