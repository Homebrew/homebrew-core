class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.07",
      revision: "bc853bdee5c2b34ae0423e5c2c9f1b8b30196bcb"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4acd6c97d53c62faf6489aabee577881f45fc6f62aa31886832c6bb67bff2f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49baee3255f1bcdf549af5bca81a153d575092703653122a91a6888c5ddbd093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e18ad480f7f222088556c1289776d6ed9577739e4c6b1bb634a733c075295e19"
    sha256 cellar: :any_skip_relocation, sonoma:        "567c6330b0adcf3b34e40a73038496030b8e0ae4a1ae00cb470c093864bd1a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3f5ca40bdbddc118935168c7ddf67353d30e3f62975e082565f20c031deac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8a6cb2c9345e55e69ce7dfb0d5faf9900981690e7b1c38b9ac5832efcd3c307"
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
