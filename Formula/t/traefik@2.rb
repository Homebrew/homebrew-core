class TraefikAT2 < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.11.4/traefik-v2.11.4.src.tar.gz"
  sha256 "a77e51ec5d2f9e4ee75ef96e3ed01df5545680c9cbca94f248a04815bf675b29"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7eb4d86f24bbf57f52d9fff9421ae26310cb9a4946e9469e102f6cef144c7610"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3768df220c6aa363b5ac9f79a8836589da80804f1a8f650cfcdfac328990b958"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a2957145b7df322bd25eb0260a9344695151ef94b40a81f6fb836dfef91b6d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "876333c2d692a23b9936618ca641019f6f0da88848d6944f2d1fb6717c7d2fac"
    sha256 cellar: :any_skip_relocation, ventura:        "6488310055f6602063a2329b5b17e7faedf5047035eaa3c29af09fa3520b53b9"
    sha256 cellar: :any_skip_relocation, monterey:       "f1d66f3c096c9b26f7c9353adffc62f404ec738e057bb34cd0fa6af2d2a69a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a4cb4cf4b9f5abb64001fe022368a9a24483dc66924ed92ade37e463a9c688"
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
