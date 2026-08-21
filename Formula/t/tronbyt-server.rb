class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "2ce4b42d8fa6b6eb57115c2d35f3df13ffd06d36386f820c90295bb363eb6dce"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "632af4f5a4ff1bff2ce1570b2a6445f20b01405e21017904a05b9b8575547da5"
    sha256 cellar: :any, arm64_sequoia: "844dbf1ff3a9d3d23bff28cf96f06a7f2008546ed43b318c97ce2fdab44eab9b"
    sha256 cellar: :any, arm64_sonoma:  "701783e5d33e688389507b3977404b15a086f84ead32a75c8b322da2dc7d405b"
    sha256 cellar: :any, sonoma:        "0c1d4cda0953fb0f30230548d8b810aa1a372ba9eb53bcb8b792c1d8437eaef3"
    sha256 cellar: :any, arm64_linux:   "dff4e1efae89d621c6b25e21ebac82d85ca53b06e0bcf38b4ddaee318cccc473"
    sha256 cellar: :any, x86_64_linux:  "7a513aa1960766df3eda22e457b3ddcb2b7d7227fe4a04dbe85a5c91c672b4b2"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X tronbyt-server/internal/version.Version=#{version}
      -X tronbyt-server/internal/version.BuildDate=#{time.iso8601}
    ]
    ldflags << "-X tronbyt-server/internal/version.Commit=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"
  end

  post_install_steps do
    mkdir_p "tronbyt-server", base: :var
    unless_path_exists "tronbyt-server/.env", base: :var do
      write_file "tronbyt-server/.env", <<~EOS, base: :var
        # Add application configuration here.
        # For example:
        # LOG_LEVEL=INFO
      EOS
    end
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
