class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.25.2",
      revision: "3b77a24892365708bf9d766126af0e4f11c00d78"
  license "MIT"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5124b25573fbe94dab18d614aae7ef3bc1def249979c39a623d43ae5bf771330"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e20df9023c9b28ffc887ff97a684b0c2f5b07ff3317504664ca7a19c6fba072"
    sha256 cellar: :any_skip_relocation, catalina:      "05ccb8f677482ad38bf372e6bbf0559e029e715b64b46fa123b2dec127fd7737"
    sha256 cellar: :any_skip_relocation, mojave:        "8ceb1cac7e4ecb5e6ac4eb7f582298ef2dfb93b8a04522c7f46c17b625b02d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c714de98b4d1463f3340c52c91adb635f008d207fca09cbff511229a7c6f38f8"
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{Utils.git_short_head}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-server", "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-cli", "./cmd/tile38-cli"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats
    <<~EOS
      To connect: tile38-cli
    EOS
  end

  service do
    run [opt_bin/"tile38-server", "-d", var/"tile38/data"]
    keep_alive true
    working_dir var
    log_path var/"log/tile38.log"
    error_log_path var/"log/tile38.log"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/tile38-server", "-q", "-p", port.to_s
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli -p #{port} server")
    tile38_server = JSON.parse(json_output)

    assert_equal tile38_server["ok"], true
    assert_predicate testpath/"data", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
