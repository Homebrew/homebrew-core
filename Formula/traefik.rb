class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v1.6.3/traefik-v1.6.3.src.tar.gz"
  version "1.6.3"
  sha256 "648415b47e7a0d2b8a3b0618624dc8e2a14c43cdb8ede4dcd21e6409d1eada3d"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74dd4217ad1739b36ab0507f3ffe25f72b200112d924d31eae22b5b3dd123e50" => :high_sierra
    sha256 "7884817ef32fb915a2dd9d987bd2ca7fe8c4553828cfef5c32cf345e1c3af833" => :sierra
    sha256 "7cef0d827c94f8e65fdfb3e6bd84e4967a247bb4fac9e9a202b471471ab5e059" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containous/traefik").install buildpath.children

    # Fix yarn + upath@1.0.4 incompatibility; remove once upath is upgraded to 1.0.5+
    Pathname.new("#{ENV["HOME"]}/.yarnrc").write("ignore-engines true\n")

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
