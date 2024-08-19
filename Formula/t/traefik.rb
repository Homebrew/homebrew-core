class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.1.2/traefik-v3.1.2.src.tar.gz"
  sha256 "d8cada1d42e2fad4cbe15b75e8db21647b520ffd49dd09814cc1131c3fe02d00"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d43569010ac55a91e8cae4f74ddb69e26feefc00fb89a08808bdf4ce005fb02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74b5caaec0fbbbaa2f4f1aadc5540a716f56d6c3ccb2589b11c6a6838fae7ebb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b6fdb41c7ee9c7ab9d8c128acfd8aca5c059fb6e77df84558d0738867239e45"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9758989dcd689d2c86d725b1af1a87b39443bce46e727ff2cd00097ad975fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "e8686a354d9b77f8f31a8c324012edee5517b01075ef4ffffac4c7bce83309fa"
    sha256 cellar: :any_skip_relocation, monterey:       "b24457758f54ab2c7cdb5150b427eccfd6c4d438945241d528ba4af411adff4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15b221a1c3e949384807e7f0f691a50e9c2709d3d71cde3edb8fef91131547c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
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

    (testpath/"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

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
