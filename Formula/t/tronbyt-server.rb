class TronbytServer < Formula
  desc "Manage your apps on your Tronbyt (flashed Tidbyt) completely locally"
  homepage "https://github.com/tronbyt/server"
  url "https://github.com/tronbyt/server/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "581e71512995d6bbfcf4d9a661cff4d1fcb1e29d67523049214343bac6b1668c"
  license "Apache-2.0"
  head "https://github.com/tronbyt/server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "be6cfdfeee63217a5632baef8d18ea87575de3330f3b357b1993903b7dfa31f2"
    sha256 cellar: :any, arm64_tahoe:       "5497137b68fe10e16b83da584465e7092b81c17141ec45362dd4cad59d5e462b"
    sha256 cellar: :any, arm64_sequoia:     "6341a1f699235d587b970bbfb3d747bae967c72a9025612269035577742c5f9a"
    sha256 cellar: :any, arm64_linux:       "8022f64c8bc6938b6aab4f14111d48a527633cc1fa6370321bd1f7e9d9a88b58"
    sha256 cellar: :any, x86_64_linux:      "c0e15d49516486797d1680bfbb55eacadced18d9615997d5c95dead28cc59b72"
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
