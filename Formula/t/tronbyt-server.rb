class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "a31cac05eeb9e60fc5dc4b584a6524ce4c96ba6dc3b8147c69a2dba9fefdd053"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ad4638c1ed68260e7844438f42bcf65dd90ce6e64dde1270ffa2f589685754c2"
    sha256 cellar: :any, arm64_tahoe:       "f2ea65184893ab2d49488e613449d54981d0ce72a0deabb7dbb99eba7e98f881"
    sha256 cellar: :any, arm64_sequoia:     "6c353c5464e8ca59886f5bfecc122a3816d9ced49284df63da5068e6378dc2e3"
    sha256 cellar: :any, arm64_linux:       "c5a1ba5fc8eb45b0cb1419efe588c911fdb5a6b80ee86f86592187e550ef5e3a"
    sha256 cellar: :any, x86_64_linux:      "6bd36255ef46d563d7ea42bf2047281bf41cc69c492b67c21b268361bb2d9964"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "webp"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X tronbyt-server/internal/version.Version=#{version}
      -X tronbyt-server/internal/version.BuildDate=#{time.iso8601}
    ]
    ldflags << "-X tronbyt-server/internal/version.Commit=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
  end

  post_install_steps do
    mkdir_p "tronbyt-server", base: :var
    unless_path_exists "tronbyt-server/.env", base: :var do
      write_file "tronbyt-server/.env", <<~EOS, base: :var
        # Add application configuration here.
        # For example:
        # LOG_LEVEL=INFO
      EOS
    end
  end

  def caveats
    <<~EOS
      Application configuration should be placed in:
        #{var}/tronbyt-server/.env
    EOS
  end

  service do
    run opt_bin/"tronbyt-server"
    keep_alive true
    log_path var/"log/tronbyt-server.log"
    error_log_path var/"log/tronbyt-server.log"
    working_dir var/"tronbyt-server"
  end

  test do
    port = free_port
    log_file = testpath/"tronbyt_server.log"
    (testpath/"data").mkpath
    File.open(log_file, "w") do |file|
      pid = spawn(
        {
          "PRODUCTION"   => "0",
          "TRONBYT_PORT" => port.to_s,
        },
        bin/"tronbyt-server",
        out: file,
        err: file,
      )
      sleep 5
      30.times do
        sleep 1
        break if log_file.read.include?("Listening on TCP")
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
