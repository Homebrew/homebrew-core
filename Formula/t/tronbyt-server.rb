class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "e51844b66c5eec002117ccaf4637beb7b13d2021a0cf7471e5a87dd85063e52a"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a560fa03f8d98cda51c8883da2f208ff768e94eeb215b3f9ac977cbed1445bfd"
    sha256 cellar: :any,                 arm64_sequoia: "e16c79142dcab4db366a47e5ad76239dade67339646bc9bb324b3e1eb0ec3d58"
    sha256 cellar: :any,                 arm64_sonoma:  "b666f8e009f1198d27fa483f49d5402491e9ad2020a09a494c380b44f9b95e71"
    sha256 cellar: :any,                 sonoma:        "cbbd38ddb9d8ff470755b7d32d468fd389c76ce0f8f266af500b06599a4ee286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc7e5fee0a570634dd80c60e69565ebd0e399998e7a253f06de3aa5eb9c0c084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50fea72d5e6c478203ae679c3fb7c24b26bf80f4ddb66205a037bcc18c5c909d"
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
