class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "4c5ea532b5463968fa79dc88eef3f38242745e7c5900bfc10b3cbafe31102e3e"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a8790f1f85f2e90c6f7cb6757761932eac82f53c572f7a8519af8e651ee032b"
    sha256 cellar: :any,                 arm64_sequoia: "05b1146101fc410fa5eaf6b36b5c62c5c4255d4cd90dd686f0e920c4aecc988a"
    sha256 cellar: :any,                 arm64_sonoma:  "1f931a549398d32a12d87c4645348401ac4deeccac35d2b50c6f7b45e9797cd9"
    sha256 cellar: :any,                 sonoma:        "ec2e1d1a447a64a9a9358ab687fe7b8915bf113366c78e59ceb407ccb33f3537"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81e7078c03d66537a07ca1cfd30d7102e309c8c3a2da4fb5f05afbd6637107cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b84992af521cec3d324b4269bdcc4527ad01dca6e14baabc1fb3fcbc79f956"
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
