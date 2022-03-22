class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.95",
      revision: "8f0410af2c01e158e85a635e3d6725ac6b966e1f"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd8ce97e34ce766c7e46b2682ae948fe88573349a1a974927aa3b54bbb3aafb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b65c99beb58b28d328fcd15021d60112398a711e65f4a6c3a579886e2be6d61"
    sha256 cellar: :any_skip_relocation, monterey:       "71f25202856dd6fb2a7e041e9d97f14d955ac5c49d2145d40ba74b6afcbc0d24"
    sha256 cellar: :any_skip_relocation, big_sur:        "73bcfa638eb415ba3fd9366b51d068d3167b9031396a3f7b1f12874f46236afd"
    sha256 cellar: :any_skip_relocation, catalina:       "f8dd9000b95887a979dc25b0db16f3a79812d6f9f25e437f11eaad573dbcb83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37fcdd2f366815d24c3b7e41fc7adf93fa8712f177975be9fa5a7aeb96cc262"
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
