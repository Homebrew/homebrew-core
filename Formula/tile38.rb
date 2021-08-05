class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.25.1",
      revision: "6e52e3a7eb49266b5c91d31debf44d2038892ebf"
  license "MIT"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c08ce07f1384c335403329dd0931bc160954cb1e385399391830051cd0dcbc6"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1b83e9d7c3dfd8a6d4350c40feb3c27689e5890e505d6b7727c201c2489989c"
    sha256 cellar: :any_skip_relocation, catalina:      "987bd7bd76b6a25f931bec3b48cba4e28adccf01ee7495dd5035e1f13b3905d1"
    sha256 cellar: :any_skip_relocation, mojave:        "bb4299bcc3ef92d1168dcb259804a70df37d0e9cbbaecf06b089e40d6507276d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31616627647c901cd2c83e6de014a08e7b42e9d0fcfd694b7023d1cf5615dc39"
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
