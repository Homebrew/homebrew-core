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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb57357e91203a07e387f9412d5446b8c1b948383edd14bfada19cc50a398a5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36eee1dae3ad707c2941cb770986571264cd014bcc8688d75f22e5186dce36b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb7bde81e8798907a6eff0f0a7d5682409d58e8f9b2e4a16d257dfbc3b963efc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd9cb445be23294003382636350eaa0f98a2d792cbf79385e91e4cd4b2b4b06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f2259e4323048a92da034e8c753b57ec8935cf262c52fae9aee1a30b9249873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891f187f897a16fe9a74dff6ce1982eae8b6761dab936d5ca43a35bd70bf9184"
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
