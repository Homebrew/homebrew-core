class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "897e42e5e9291ac9a6e39f836d789c115a8e9b43f36d1c61c6534a7084646ee6"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "581cbe0721e424652300c79a5bacaaff8fc079f736540b9960b17dc802f99d4b"
    sha256 cellar: :any,                 arm64_sequoia: "d1936b051783f7da02dc988673eb36a0d817b43f9ac79e71fa521cbfa8ddbcca"
    sha256 cellar: :any,                 arm64_sonoma:  "db08c9c80ef39e7e51798be851f6fa8c3e5d5f0bfce8ae3ef8af346a498c23fd"
    sha256 cellar: :any,                 sonoma:        "7017bd7eaa97db92c93b22ea211f1ad4487e22c45dfcd5215c92565995705862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "290dc12d9bcf6afd6cab6cc97fe648b573e3df95187b47de59ee48d31031cfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ec54df9eeb2f97fccee7963b33b50aeb608cff2fb045eb3b4c4b509831652ad"
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
