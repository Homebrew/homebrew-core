require "language/go"

class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v1.5.1/traefik-v1.5.1.src.tar.gz"
  version "1.5.1"
  sha256 "8d052ba499ebf162bb7f110cbf45f630c5490dc6a682c35c39ee79d3c79463d9"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "57297d433e50740e1561ddd270f9f9760c33a8f3a597fd99332a550187239741" => :high_sierra
    sha256 "6d05f4bc5ade3cd24d38063e91393470b1b2990b243c3d7db17fccf5d8f021ac" => :sierra
    sha256 "b8c5012724cf9ddb0028dcd43708f61d71f782c2ac218da5967a1ed7ab7a53b8" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  go_resource "github.com/containous/go-bindata" do
    url "https://github.com/containous/go-bindata.git",
        :revision => "e237f24c9fab3ae0ed95bf04e3699e92c2a41283"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containous/traefik").install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/containous/go-bindata/go-bindata" do
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
