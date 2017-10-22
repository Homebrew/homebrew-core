require "language/go"

class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v1.4.0/traefik-v1.4.0.src.tar.gz"
  version "1.4.0"
  sha256 "9c8663796986127c3b348735c1754a1dd2d841317d4739244742681563d6c3e2"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87b7ed2e581d07e8e803fd53a7c6b1f76d26eac50d4adcc66d7d6855f0768563" => :high_sierra
    sha256 "a0939de20f7ad4bc6687cc31609e82ea6a3fcb4976004ebd07cbb8d7168453c6" => :sierra
    sha256 "7a0b9b246236de6cbd47e663047fe0869245294a44474447d6774d2afd141d5b" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containous/traefik").install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

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
