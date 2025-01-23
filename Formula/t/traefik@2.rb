class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.18/traefik-v2.11.18.src.tar.gz"
  sha256 "cbc14fe7e1d77faa645206b2e7f36868f05fc7751260ebd34f6c74c20ec520cc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336267651397da6b36dfaa44291301487cb3be5febf19abc4ea760a8a3895a93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32e7824853faf1fe70bedfac97b87fad93f03b9202827a83c55fa38aa21bb8d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8dcbf061ec3d216f6c522d03ec3bed11cdcd389fdcb450a06e3d2924e09027f"
    sha256 cellar: :any_skip_relocation, sonoma:        "60a642928039aed30f99613ae91712f1d33d968f0acc25e7b9e1b554c6ea887e"
    sha256 cellar: :any_skip_relocation, ventura:       "9caf27dd7d3a2fbde7d731cd754d5adcaf8cdc6eb318bc797f7246ddda16e29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16fb2139f216c4fecf5206fe4e65ba3d14a473789b816ee8e2df62974bf4f82e"
  end

  keg_only :versioned_formula

  # https://doc.traefik.io/traefik/deprecation/releases/
  disable! date: "2025-04-30", because: :unmaintained

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:, output: bin/"traefik"), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
