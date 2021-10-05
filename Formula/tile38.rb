class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.26.1",
      revision: "72b3683f27dac650aa38174c7fa3cda7c211d677"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c41a9f79bbb5e0ed8eac4a23e1669380595218c28992783cc80e19f33a245610"
    sha256 cellar: :any_skip_relocation, big_sur:       "efcb79971e76639e09fcabf2c2188c3653f5bf9cde4572e0d9c77d8b87697161"
    sha256 cellar: :any_skip_relocation, catalina:      "6c622e5d2cd6f0d9457ecebfcde4c4a254a7525338e579b66af2b2eb3c7894d9"
    sha256 cellar: :any_skip_relocation, mojave:        "2397ac31817cb6ee8aee1ca2edb6aa1c8667a44de559482ab03989008f37e6cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb3bc55ca42bfcc0e10cecb803254a1ad708b97c85d56f52b3c4f742b063685c"
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
