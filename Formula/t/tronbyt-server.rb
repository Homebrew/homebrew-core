class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "9ff87569b6a30fec6cc7be0599c1441ec19130cc4d69a00287722e98fcd4adc4"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "28ad3b9769cc8021282b221695a9dd616747d466a3b2f1f1533e5506729afa8e"
    sha256 cellar: :any, arm64_sequoia: "2ae079d887ed0b8555ec5a03bc5e929ed712277be680e8eb53bed5d97b45e935"
    sha256 cellar: :any, arm64_sonoma:  "a453b1453d9531afa122da7209c566e0c281000a2314c648674ed2130721b8ac"
    sha256 cellar: :any, sonoma:        "dd85ef388a0cfb895f0f41bedfdf9c11d15420c0bba2cd88180a683d098a92ed"
    sha256 cellar: :any, arm64_linux:   "90050a62ed25ac2f94694df3358a6ce42a8422b5e9c54ce692b3cae671366fbc"
    sha256 cellar: :any, x86_64_linux:  "e5e1d8c9d5a0286e113a0d3fe126cd00201d516fb9068de69ed21535d41b8a95"
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
