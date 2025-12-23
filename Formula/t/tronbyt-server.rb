class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "785867e7e84b62497df4346e9ec7f402bc495532a4df7624b5aa199ec337935d"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27a2e16e65d019ddfca118b6a605f4269c51b480e7ddad61542bb67baa4bd661"
    sha256 cellar: :any,                 arm64_sequoia: "68a6401915ca2ea4a25942ca19af3cfc25a4ceee17ab329ecc0b492ce5d1ea26"
    sha256 cellar: :any,                 arm64_sonoma:  "694fb1c30f88ca46ab4cd9fd2b771f5fb70abdc7b304b4cb8a622ae17b49194d"
    sha256 cellar: :any,                 sonoma:        "2c3019d83299ac73baa7d716cb685e08146227deadfb4d4943540c851118bebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3197e73468d9479d115daa38ddbfc2b096b92894d8d872ea4f8d8aa6c821db1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a48a5ff884660e3f54ffa2f0c539638bf783ef5f38fa7691f328e8c7f287a1"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    commit = build.head? ? Utils.git_short_head : tap.user.to_s
    ldflags = %W[
      -s -w
      -X tronbyt-server/internal/version.Version=#{version}
      -X tronbyt-server/internal/version.Commit=#{commit}
      -X tronbyt-server/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/server"

    (var/"tronbyt-server/.env").write <<~EOS
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
