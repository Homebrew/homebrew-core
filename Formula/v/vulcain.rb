class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "45c264a62cc1e607baaeaf4e223bdac871d0a572ccd39cacb9d403642936a108"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24cfb569242dbdc29e9725ba02dde277848813a0d5529cea711080886f20d107"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca5bd70c80597538ff622be86b533e0ad379834d9e16fa742552497cbc71c277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7df293d1a5636fe0a03462b3bbf326781e627c4cf0da7c97a3550ab79671772b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d79bd215e71eca36de446ebdfe2d6affc63837606f5ea2492a1d9b0978db2333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96d01f437570a84b53f518a4743be4797c7bc6ea7bbe63cd2de4ac7a504448c0"
    sha256 cellar: :any,                 x86_64_linux:  "9fd463d2ca38e03d26acb9a88864d19240f88741271b8f735796fa2d8eee7c20"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/caddyserver/caddy/v2.CustomVersion=Vulcain.rocks.#{version}"

    cd "caddy" do
      system "go", "build", *std_go_args(ldflags:, tags: "nobadger,nomysql,nopgx"), "./vulcain"
    end
  end

  service do
    run [opt_bin/"vulcain", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/vulcain.log"
    log_path var/"log/vulcain.log"
    environment_variables(
      XDG_DATA_HOME: "#{HOMEBREW_PREFIX}/var/lib",
      HOME:          "#{HOMEBREW_PREFIX}/var/lib",
    )
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/vulcain version")

    (testpath/"Caddyfile").write <<~EOS
      http://127.0.0.1:#{port} {
        respond "Vulcain API"
      }
    EOS

    pid = spawn bin/"vulcain", "run", "--config", testpath/"Caddyfile"

    sleep 2

    assert_match "Vulcain API", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
