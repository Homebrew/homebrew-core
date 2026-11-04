class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "e65e224349dc632efd8f1b01b965837537f93ccb4af27a359e26340faf33bc8a"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c338c0cbb14bbf142bdfba4523c03b9fc03b8a5ca221f16c637dff419134ce9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d87abd5cfc86a89c862db01869a7657a946dd65391d3fc9d1962b91fcd3a4b0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11316f6f0962f4fab1daf39ae0c49fd46bd60167e30dcfa5761826fb54fcd712"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec6debfcf261e8ad101ac0475bd216f982087b79b9580684cc7f07e9aa1503a5"
    sha256 cellar: :any,                 x86_64_linux:      "635def2aac073e4b94b906f957c6934bc55017342672be3616132b7ff34755ec"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "caddy"
  end

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
