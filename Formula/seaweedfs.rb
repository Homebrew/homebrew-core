class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.22",
      revision: "fa4d0093e17f710c3da00545022646cb96a6fd98"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cde82a44a74e76cfc489d6f99a02a45d45ee3d51f6cb16d061c4bfcd3666de7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13a856b3624cfae97c726b26c1963e0c7ba285126adfb8419ce17cde516ea0f0"
    sha256 cellar: :any_skip_relocation, monterey:       "94fc045c14018150d642caaf7e54853903444ee66a103c49c7b072e895407d4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0de3a1d0c738f903fcf66278356f2a6298ae1fe623e5dadc6ebd2167d4e7f7c3"
    sha256 cellar: :any_skip_relocation, catalina:       "e403a63ee4218d6f8320eb85ec322bb0efc628ff25b079be448adfe2cf6ae983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1109ac599b3349e68ba81dd6eae9a4425c885760db23d1d1e0544f08bc1e2fc"
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
