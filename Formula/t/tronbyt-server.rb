class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "84b130ae9071dad2a17d6eddaae9dfa1c4f1e284d302926d00312425bc7d176d"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bf70e14a597b9df17d2e243531050b69d6abcfe1232c0cb0095027ce935fbc6c"
    sha256 cellar: :any, arm64_tahoe:       "196713ad47a7cda9de3b70025e782eac6ba76bd3a093f3eb9e02f9be27fa8b5f"
    sha256 cellar: :any, arm64_sequoia:     "7fb95d2b260dcb4b2efe802dfb751dc7c852016a31963be178cbc35214cf3974"
    sha256 cellar: :any, arm64_linux:       "9e637e13a2f73c15396f57291e85e47c8f9f63144574c4a5102e9be5733d38e5"
    sha256 cellar: :any, x86_64_linux:      "b56a37ab1fe49fc82d19bf4dddeb1e7a694af8e1987ec377b3c43f58ebc5f49b"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "webp"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
