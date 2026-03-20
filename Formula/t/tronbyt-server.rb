class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "17307bc5e2916a31d5eb670faf2dec3934b400f238240a44684caa001842085d"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbd6bcbb9bbef0d376773b53f0a83717b01b4bf415bc0469e975018dd4f5aec0"
    sha256 cellar: :any,                 arm64_sequoia: "f5515fc7b28c4db70b96214185e1ce38e5f0a927791dd0df137bfe5455ff84ee"
    sha256 cellar: :any,                 arm64_sonoma:  "2468fd85501734a96d79461b1a5a68b5a184886f0e1267ef103ae2e91f47df57"
    sha256 cellar: :any,                 sonoma:        "d44f311c374909e8dc6d581b459b5e8786be2974b5f654dc7799ddfec7c79813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f138dcc697c9a4010667e589f1ae38cfe1e38633ffbf6b87d92afe7c614f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0225afe94164ea0c43c78acbbf670c1217e843a6c1fb356f3e4dc198512c2c"
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
