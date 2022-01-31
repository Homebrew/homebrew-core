class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.88",
      revision: "7270067289802307556d117be422a1e5a208f558"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd1122379391be766bb64e36936a49b006ccb3375e35ba34bb08d3d8c85c73a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77ab27ce19696e31b94686a59d8ca7011f97551cc509d61d0b5466fa51b92559"
    sha256 cellar: :any_skip_relocation, monterey:       "4d9acbd3d37b4570c8ab466e3c72b6b54f5c6638c5aacfae5e36c4ace8f07ebd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4f4e06bfa4f9bb7da77044586b9f6bbb056a6e3092324aa9dd6d90b74035390"
    sha256 cellar: :any_skip_relocation, catalina:       "dcc542c7f69fc6b5ea4c15a87af3266ab4c4689e62a4c856da978de4785e7453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ef90c5774d1d071975def48a9497a168ab748ee85ea7b04bb8a88e11a6d0479"
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
