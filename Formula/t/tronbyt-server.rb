class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "1eafb8e1f0fecde804ef241f94ec21c20a5a0ab149ec079afc84f2a7cfa1e0f8"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a2436e775e36664743c6bd3f4cece520403c5b051fde68d9eb119b9a31dabcc"
    sha256 cellar: :any,                 arm64_sequoia: "85c802c16638360aa6c47ad574eec24d4f6a7d87b2841960ba3272e8131cf28b"
    sha256 cellar: :any,                 arm64_sonoma:  "c4044bb1e8ea3331b2d310e09fa241f45a1d7f6229e4028df40d26a95c0192d7"
    sha256 cellar: :any,                 sonoma:        "addcd6fde7cf26939e4156b620ee16972da7c1e3563886c2c9c92dd59570df94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bc02323e77ac1a7d3a7bc36ffd267b569f38d4a67edb3cc03e17ba3d10bfa4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8f1c39a80b74d05b33a798dc25f7af23b746225121932742ff01a36e7b2834b"
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
