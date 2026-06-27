class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "5f306e8a047105d9afef7fcdd9ae47101d6e2a2145ba61fc1be102d8a6fc27cd"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1ad1bf8f2821ebef4c3147d0563800af349698f02a7101bc4f4cfb90df1e98fd"
    sha256 cellar: :any, arm64_sequoia: "781e002552ec996aeb05fa8228efef10883f34d97404c4e9cca82a9203fb176c"
    sha256 cellar: :any, arm64_sonoma:  "82e9be4989bb3e7cd282de4ba602a9d0bdb28a96f40ddc22f584ba81896a9093"
    sha256 cellar: :any, sonoma:        "0d9ae21aaf992edcca4343d27ac0327452bd6a816338e7a1c3737c2c426ecfc9"
    sha256 cellar: :any, arm64_linux:   "3304c0318dbd186db9d1d1f3452d81e257560c821580099bc258f64126e1ba75"
    sha256 cellar: :any, x86_64_linux:  "ed1ed7c57ec280b84f2f252bc407600a7488582b1ac3147297dba0dc61ee7208"
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

  post_install_steps do
    mkdir_p "tronbyt-server"
    write "tronbyt-server/.env", <<~EOS
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
