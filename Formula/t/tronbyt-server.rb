class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "27dc4ae2c977bf9e48516853bb0084250930eb8a99cb862e5d67c660321490f8"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f23405bbe0b32cf872c58a0af2203c3f8a658ecfc11748b3158dc1f76735f73"
    sha256 cellar: :any,                 arm64_sequoia: "c0c0b701195576636b5fcfa09b2b53dfd7cf7a2937b7c6e5e5d77ee66dc00e6a"
    sha256 cellar: :any,                 arm64_sonoma:  "2d998256f0067db6864d5dcab164cbe3aa6264d29ba8862d3f6ed6441add81c5"
    sha256 cellar: :any,                 sonoma:        "07e2d438a680016d30f73a7af6f1f04c31c04b05f2fb93d0c0b7b2b56cc58a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2085bb9ab2960019dd0a1cb0687b2ea1863b959154c0bc057c44fdce5b52f401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a95963aab6008b4c7f056ec2a8492c1a59365e38d951743f93fb33eb97a8d1c9"
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
