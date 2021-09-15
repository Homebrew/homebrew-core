class TraefikAT1 < Formula
  desc "Modern reverse proxy (v1.7)"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v1.7.30/traefik-v1.7.30.src.tar.gz"
  sha256 "021e00c5ca1138b31330bab83db0b79fa89078b074f0120faba90e5f173104db"
  license "MIT"

  livecheck do
    url "https://github.com/traefik/traefik.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0ea0ad8d89150568cc4f33c1cdaf0cc84c7e77bec0374764d4d3882820434d22"
    sha256 cellar: :any_skip_relocation, big_sur:       "6305adbf2774f44e0bda394fbd0f332309aed8dcf7432ce9eba655f693d90c61"
    sha256 cellar: :any_skip_relocation, catalina:      "c0caa4ed372cb322cf1bc5f7436206ab19ac3c555cecad63f17ec63b94054f3f"
    sha256 cellar: :any_skip_relocation, mojave:        "d0f8d61c8c23ce1b8dfd65a9f888a3b00f7f55df9480bde0486cb6176437f70c"
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/traefik/traefik").install buildpath.children

    cd "src/github.com/traefik/traefik" do
      cd "webui" do
        system "yarn", "upgrade"
        system "yarn", "install"
        system "yarn", "run", "build"
      end
      system "go", "generate"
      system "go", "build", "-o", bin/"traefik", "./cmd/traefik"
      prefix.install_metafiles
    end
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc/"traefik/traefik.toml"}"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    web_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [web]
        address = ":#{web_port}"
      [entryPoints.http]
        address = ":#{http_port}"
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd)
      sleep 1
      cmd = "curl -sIm3 -XGET http://localhost:#{web_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
