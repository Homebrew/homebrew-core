class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.23",
      revision: "73fc9e3833cfff2c259e0239ed6c0444e1c1890a"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c25aef100d4b651ed9cbf5fef322eb1ec02c78d2b84d0929df7568925bfdd402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216c5b2e27266171fed8f7984c9718baf630d56b055110165dcf21f9a0a49604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64caa41893fd7287b8679b2fb2bdf093e9f681da39e8880a92056c01a81d5036"
    sha256 cellar: :any_skip_relocation, sonoma:        "3798226f329efcd2254468cfbe030896ce5435945fb9a2e08a84effcee19e983"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e91bd40bf8b7b6e608d6db6488a0585e406aee1b8313705bd692f54aaf5916d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "369830416fe4660ac0e2e73606b7dfeff36243b791cbf5f1e4ae835b48d8321c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  def post_install
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
    # Start SeaweedFS master server/volume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    spawn bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
          "-master.port=#{master_port}", "-volume.port=#{volume_port}",
          "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    sleep 30

    # Upload a test file
    fid = JSON.parse(shell_output("curl http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
