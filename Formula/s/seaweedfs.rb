class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.53",
      revision: "4ab66fb76da83700739f5839e62fcaf15fb7d02a"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19887b82fc50710a0e890711001c06f42434b902c2ed63adbae27c0fa048d108"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fda94e372fcec06b4a09464352f83962226cce14af03f6baa32664359418681c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86bbfe8ea1e6fec5fb9d0fa4f75912d4509c6abc10c6603e7834828ecaa54eb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dbd482ed66e69c420837e1d92eb5d70a1c921741db1116fb20d473ab24bca5d1"
    sha256 cellar: :any,                 x86_64_linux:      "56737223856c89ed3d4210f1523f7cfb26a31d365abd38d417d713db28421032"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
    (var/"seaweedfs").mkpath
  end

  service do
    run [opt_bin/"weed", "server", "-dir=#{var}/seaweedfs", "-s3"]
    keep_alive true
    error_log_path var/"log/seaweedfs.log"
    log_path var/"log/seaweedfs.log"
    working_dir var
  end

  test do
    # Start master and volume servers separately as `weed server` links them via `/tmp` sockets the sandbox denies
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    spawn bin/"weed", "master", "-ip=127.0.0.1", "-port=#{master_port}", "-port.grpc=#{master_grpc_port}",
          "-mdir=#{testpath}"
    spawn bin/"weed", "volume", "-ip=127.0.0.1", "-port=#{volume_port}", "-port.grpc=#{volume_grpc_port}",
          "-dir=#{testpath}", "-master=127.0.0.1:#{master_port}.#{master_grpc_port}"
    sleep 30

    # Upload a test file. Volumes are created lazily, so grow one first.
    system "curl", "-s", "http://localhost:#{master_port}/vol/grow?count=1&replication=000"
    fid = JSON.parse(shell_output("curl -s http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
