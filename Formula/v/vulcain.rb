class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "6d33bc7f3aa3d4d792d5a52745e245fbd033f566be28e4a726634ac438d9a999"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "503323e6c2405743989752d2584642a408a33ba164b8773d29bdfa0ee8cd31f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff955dc1738bbce313a12cd0db2085229eb84f23638474616e7203703a03b033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5e30151103dc7c5c02ac72f1807b2f455d78196aaa18e18703397a62f4d92bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f925676010699716b4246457e77c5c97d123d7aa448de805265ece5f2c4d77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec6d54298bc0eb866985ee9642ac361422086773e2abf7be6439773f21015641"
    sha256 cellar: :any,                 x86_64_linux:  "4c9f24a2d2c8c22bdf77b73e02470e03e967db83bfbe205b503372cb7228c5c1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/caddyserver/caddy/v2.CustomVersion=Vulcain.rocks.#{version}"

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
