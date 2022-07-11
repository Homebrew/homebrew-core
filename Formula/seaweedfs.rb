class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.15",
      revision: "37578929d4f74ec9c8b610df691918b79cee79ca"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca273d676c654e906bf2bceb68f1e60374304b71d9dd2e2d914261cd78a425c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1c1cbf51a2cb0f87807a562f1fc011c398669bc109f3a3a1467572669325b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "28f7d0adbc3dab67d3ad1165ccdb70d9c69e2c9e51e638761fb94819a2ec01ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "637cf56352923be8cdd23c31d4e38bd37155ac183dec02a66683983a71e91325"
    sha256 cellar: :any_skip_relocation, catalina:       "bca11052fbcaf809ea8f3fe7262821ef32188198fe1d844d95a3fbf48c3c1794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e38b68120d0eaad89b11a602fa7b4f7ca678f270173dd6ce2b8a8f2a5da1aca9"
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
