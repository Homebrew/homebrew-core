class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "4c5ea532b5463968fa79dc88eef3f38242745e7c5900bfc10b3cbafe31102e3e"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4396ced4c747b73cfc48571484ddce6dd4165e83ddb410ae8da1ca3de5ff3b87"
    sha256 cellar: :any,                 arm64_sequoia: "c4b5f49ac4925df7990e96fc87ffc35029264cb21ce756f72507e893c3ef4dc5"
    sha256 cellar: :any,                 arm64_sonoma:  "4e168227724429c76973786a0309c4828fddfe71f0af24bc99d5d5bb908ea42d"
    sha256 cellar: :any,                 sonoma:        "e6ae27b1290d8417b108248ff6a2d0ccb4829e24ebf521ac4166786ffb3f0907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bca4c5a14be8de31d3a80ceef17587621cd196dde84fc2087e646c268aa5727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d34d82e0202027838297db69327a86e19fb19c3e6dd9d5ba7ae5f592b5f5f44b"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X tronbyt-server/internal/version.Version=#{version}
      -X tronbyt-server/internal/version.BuildDate=#{time.iso8601}
    ]
    ldflags << "-X tronbyt-server/internal/version.Commit=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
  end

  def post_install
    (var/"tronbyt-server").mkpath
    dot_env = var/"tronbyt-server/.env"
    dot_env.write <<~EOS unless dot_env.exist?
      # Add application configuration here.
      # For example:
      # LOG_LEVEL=INFO
    EOS
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
