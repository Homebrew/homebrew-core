class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v1.6.0/traefik-v1.6.0.src.tar.gz"
  version "1.6.0"
  sha256 "4ded85f0afdfa602963e5924cb94dc0d9a2d62b05519871e26eb3673da7c0074"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a33180715ae28b562b3a3a00baf48a17f3850cfa575bdb8ee743d60b90fbf9fd" => :high_sierra
    sha256 "6015b747e8042458068cd9745ea87337a7a9d1f84fee9af35fdc2240f0016759" => :sierra
    sha256 "ce504adf3660e038766ba4f795ce7fbc0dfb992de6b5b0b362340be592e972b7" => :el_capitan
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
