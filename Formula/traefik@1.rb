class TraefikAT1 < Formula
  desc "Modern reverse proxy (v1.7)"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/archive/refs/tags/v1.7.34.tar.gz"
  sha256 "0f068c2720dadd66ce303863a80d2386a4d13b5475d4219ba3e65b8445c653f2"
  license "MIT"

  livecheck do
    url "https://github.com/traefik/traefik.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e31f7d05eef29c95084bfca1f7dae694b56a6926e4810e1d151d7a483c1a93a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e8060b579d2b50e927526da6c8ced95ee5b297a15085e2358651dff21aa41d7"
    sha256 cellar: :any_skip_relocation, ventura:        "fd0dd9a960fbb6e5abd966c41e6c4423ec5b4051954e7d17b57d72f7d4da5c53"
    sha256 cellar: :any_skip_relocation, monterey:       "66cc839bf105e161e16aec5b056c5a5c908d7d5fbe2fadb5668614d8c764e783"
    sha256 cellar: :any_skip_relocation, big_sur:        "95d3b3da8a19aa4cb133c8e5b95b63a957551732c2a81fb4b80015dc84df0237"
    sha256 cellar: :any_skip_relocation, catalina:       "a1f090529ee3ed1646d872898219662f76d215c5cf7389cb84d4f22e540b7afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69adbe00d348f14f732bbd9fe57d57e6f513f6f1c72f5ff2f4e09fae5b4ee2d9"
  end

  keg_only :versioned_formula

  # support ended 2021-12-31: https://doc.traefik.io/traefik/deprecation/releases/
  disable! date: "2022-12-31", because: :unsupported

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
    cd "webui" do
      system "yarn", "upgrade"
      system "yarn", "install"
      system "yarn", "run", "build"
    end
    system "go", "generate"
    system "go", "build", *std_go_args(output: bin/"traefik", ldflags: "-s -w"), "./cmd/traefik"
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
