class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "d42803215c2ce758bde84b8f09b687af66cdbf47ff270e675937255053362114"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4162a3f2aad218c61df4f7ee477bb580b71a4a26f42d471cbfeaa65ce02d4624"
    sha256 cellar: :any,                 arm64_sequoia: "e7367a94106f40a89eda4371fe436a79826ffc820ed97759095fa72febb8d3ec"
    sha256 cellar: :any,                 arm64_sonoma:  "517113e6be7752ded4d76e9f9737512a1b73ad88589b1dd7485b72dd1fceb086"
    sha256 cellar: :any,                 sonoma:        "56356219454f35e1179e5be4e97a08eb5d68274876e8672cb89e92efc3832dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32563c69056092d1066adefee489df97136b4a6397f950f924759af41821dbe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0341a69d44366a32188cccdac343af056e0a2537c321c3078f8d6a8315f9a84a"
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
