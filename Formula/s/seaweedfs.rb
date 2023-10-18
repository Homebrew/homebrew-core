class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
    tag:      "3.57",
    revision: "0f8168c0c928bba3d2f48b0680d3bdce9c617559"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08bea5cf9e25f7a0f1ae3664812bd9b3f384783b02421a6730f689f9ca3ef7a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32fbedd88f02f28d272a9f1d011ef29770f61522f81377ce1ecdb8e659c0d88f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3098428951226f5b1217cc5352bc09dd483866d947149f2ceb5716069ef2e059"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80d7ed26a580df11774be422257b5c37a7eeac07d93fb5f6d9d6f048e2360045"
    sha256 cellar: :any_skip_relocation, sonoma:         "951b643dfc720b1d1a3102f9606337139e778f310d53167a066bbd6570b647b2"
    sha256 cellar: :any_skip_relocation, ventura:        "493e8151c85b34ef55c3417a1dbf536f3c6d38fc5b4d9e2d306b475765419010"
    sha256 cellar: :any_skip_relocation, monterey:       "be067f2b5e660ccc15d9940b1819c60001be6343ab25f4e88b8e08206697add8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c0e8a268587d82e78d28fb0b4e578987def95391aa966b9092e4859e5d221ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fadf925ebc5f4fc3a54ab96e82f6dc104ddc83acde1c6aebd44ce31963ca1f5a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
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
      exec bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
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
