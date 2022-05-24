class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.28.0",
      revision: "036017db4f8c5cbe6533d8e0770159d7d87be40a"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7002e4724df6232a58a20467340185de9168d8a0940c9f9a44b0fb2c3e4e4355"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c2b987986b1c40ed0b9d183f8397951a60ff5d46b24eb153ab8a59fbd512c44"
    sha256 cellar: :any_skip_relocation, monterey:       "351b9ab53c7f9fa08bbcf9121c9eef6acefd5b4eec78a25c29fd0c3569c1042e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1d6db2eb13e29e4b9c0de0596c3486d77096c7575b129199117bffd8e6183cc"
    sha256 cellar: :any_skip_relocation, catalina:       "28ec4ac40256f754d6fe1ef98420c7e242432eb7ee3cfe3e3925343ff51e947b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaebcbc22c88670654e38ed19f82a0a66366c18d4812bd1e6e477f35c654c04f"
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
