class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "e16b0e691cb348d1622dc1dfdc12134a09d1c1d74559d220b9a5de55057983fc"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4da72bea38381670016d909b73f456958bd866d63b3faf61fdbe7c69bd9b8cef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42357e323eb416eba8992d1c3a7b7f5cb63f66cf5e609c6a1b54db94fc13d07e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2581c5b6a8355054edc3ace06c0c3940ed383ce23e98a91f1b2c45e975ca430a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b3192b285bacca9f127643acbc34540c7d35393e46871cba2556d9488f2f94c0"
    sha256 cellar: :any,                 x86_64_linux:      "85607cfa42d6a60cef566dbf0ae7a0c765146955b96f456eb18b924281a2267c"
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
