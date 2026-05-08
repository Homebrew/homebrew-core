class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "464f9d9e018eae43bf373ee021e6e3c9ba1d9a03e091b20646e0e6ec2cb67bf2"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "50e0dac8d3905b6aac968125d60ceda85d574f553034fca041692c9bacce5a83"
    sha256 cellar: :any,                 arm64_sequoia: "b8ffd970cc588d179211f67bbcddd1685d66b57bef2a79ae20d9622c418eb0fd"
    sha256 cellar: :any,                 arm64_sonoma:  "125cdf0df044e00e721261c40d43998a8b72eaf31ba28ee7dede28f7ff4814a8"
    sha256 cellar: :any,                 sonoma:        "3a6af61e34f5433420f42a4e36c0f5bfc06a563437fdc34663fe6fec48bfc848"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb734aaca32dceeeaf881fb9b72572a739d3743ceb74d071849e478f56f1e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5a38d361527d34dc75e638365b4e688321db36c8c423c473cd11ce9bb59ce6"
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
