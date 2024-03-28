class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.32.2",
      revision: "72478a5a6f4e00f68999909554f9c184215522b7"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83e4a7274e2626abf82ee23f7206d920d5f946c69c0ac2612c228418577af699"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca1f31928c8d77a2e0cb96148f2794aa754556bbd799110f0362d1cbc9063bce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f645698f89dab4154e836e6d016bef2d7f19befae8d10583943d5f4847ce4670"
    sha256 cellar: :any_skip_relocation, sonoma:         "40950c86d95fdda80e26999868009cfe7b68035fc0a7ca465af3a55750d45553"
    sha256 cellar: :any_skip_relocation, ventura:        "30b0adec07052e7a66d4d857b1fa124865777b0a27dceb74e6c5ca7d043d5a44"
    sha256 cellar: :any_skip_relocation, monterey:       "847f9e257a406cf2afe6a86aae6eaae59d20ac11e6a7634c09dd2c8af89ff742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48d410c3c285e94de525a8a46610829ca41630114fb7f4f6ee13083e38f5f1f0"
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

    system "go", "build", *std_go_args(ldflags:), "-o", bin/"tile38-server", "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"tile38-cli", "./cmd/tile38-cli"
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
