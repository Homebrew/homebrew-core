class Vulcain < Formula
  desc "Fast and idiomatic client-driven REST APIs"
  homepage "https://vulcain.rocks/"
  url "https://github.com/dunglas/vulcain/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "fa93f5d9352528ab708ffa5ec472841715622775ed66566e6a4acffe37bda3a1"
  license "AGPL-3.0-only"
  head "https://github.com/dunglas/vulcain.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34108eed78b90ecf9bfb226f00b5575c643b1e200481f26b38261e1e307f6667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d66ada4cf084c070d807b00d8f50485ec0ea04b1054746e590f51f229dc3bc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a001532c5aa5af0f63ed71fcef98f27a210d456c5026fc495447a8c9709a6c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c700bddffe1611b308f117e9dffc3c4f6e4c03222a1e35cc06ea9302f5eb371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e762cba8245ecae0c6aafd13c4ada647ad0be0a1f7f1d42cd90fdeb90c849f4f"
    sha256 cellar: :any,                 x86_64_linux:  "6ad2b99a1e45a559aaab10d02e6d908ece6850cfea431fe7ec775bd5bfcae206"
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
