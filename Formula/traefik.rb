class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v1.5.3/traefik-v1.5.3.src.tar.gz"
  version "1.5.3"
  sha256 "3194e721dd739e7be09fdecdf5ec1a70a55f019a773f1698b9d642583668288f"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a94770c0cfdd82e419e2bdc0672a21aa9a1d592fe76997af9977793d9d628afe" => :high_sierra
    sha256 "6dda878842677bf5b1fc96b2dc30d3ccca4593def4d7b8f345f59e0424b14a37" => :sierra
    sha256 "e145a36f35101f8e5ebabeb56fa25b3083a426845b032f341df268506371c6a8" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containous/traefik").install buildpath.children

    cd "src/github.com/containous/traefik" do
      cd "webui" do
        system "yarn", "install"
        system "yarn", "run", "build"
      end
      system "go", "generate"
      system "go", "build", "-o", bin/"traefik", "./cmd/traefik"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"

    web_server = TCPServer.new(0)
    http_server = TCPServer.new(0)
    web_port = web_server.addr[1]
    http_port = http_server.addr[1]
    web_server.close
    http_server.close

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
      cmd = "curl -sIm3 -XGET http://localhost:#{web_port}/dashboard/"
      assert_match /200 OK/m, shell_output(cmd)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
