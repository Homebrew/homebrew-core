class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.85",
      revision: "19555385f7b99bce0e1f562f3cd4a4f440dd3d8e"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f4cc22403f0210f7bb910f2c7cd71de7fe9ecb00df9c9c291c3f7781f3d4065"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb5caeca74bbbf1d06ca0664e2824ae5de3f341f7b5e1a6e4b8f1bef767f3070"
    sha256 cellar: :any_skip_relocation, monterey:       "ad5002cfb727f8ad5de09836bc4991fca4b21e1101106b87b436525100c3d975"
    sha256 cellar: :any_skip_relocation, big_sur:        "4883c0c261b2e0f6f209d81c8bd61e1427011a8340e1ebb3ca68553e96be83f7"
    sha256 cellar: :any_skip_relocation, catalina:       "87a53c7da3c6344f521823f2a77acc581e7eadeee04146cd638dc4bcaab273eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32f4253c429f9d7ff2888e0decc4b2c83ecd53f66aa47c6600d3d25744891d8f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chrislusf/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"weed", ldflags: ldflags), "./weed"
  end

  test do
    # Start SeaweedFS master server/volume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    fork do
      exec bin/"weed", "server", "-dir=#{testpath}",
           "-master.port=#{master_port}", "-volume.port=#{volume_port}",
           "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    end
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
