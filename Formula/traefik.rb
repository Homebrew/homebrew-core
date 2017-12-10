require "language/go"

class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v1.4.5/traefik-v1.4.5.src.tar.gz"
  version "1.4.5"
  sha256 "4f109e5625bb602b87f6b5f859e7ce9a00ae15cf06eb238f43600db740089d4f"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c8ce0d9013c13075285a85a6ab52816c57299b72f94e7d13455ed7b263491e6" => :high_sierra
    sha256 "4f91d5509495d37ac755b4e043aefecf4f509deb1d4a1317a158fdac0e74422b" => :sierra
    sha256 "21558dec67c11ad922e7fab805e544e3da85c45857bc89e69124e44cca39ddf0" => :el_capitan
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
