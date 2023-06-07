class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.52",
      revision: "fb4b61036cd6389b18efc5343b766b1c5512ad1c"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8720dbbea890ac6478dd25a991f35be58fd0a0fe6fe3fd020e939b4ccd6314b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "009fa7b38e3ddbf658f528490e2eea29864383c343d85f2ff657986fdc98916a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0a26b0fb7d94a33f2e743d7d9714600d7c8dc68dc3fb8698afab3b3eaf92bc2"
    sha256 cellar: :any_skip_relocation, ventura:        "e01e49bd351ba15095dc1c4855c8e440df3702b1fc1457cc207ba078038e8f58"
    sha256 cellar: :any_skip_relocation, monterey:       "d86fb5eadd44f6e3a87d05d256835a597633629046e0064631d265d2c8f6fdb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bcf7521436acbc933141895d1812505c9b5b7ce0642e53a0dee0b3f3c3800ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd2c6ac09a47fbb07176d9ca3e339e0af200e67b82ee826877a446803ab65c17"
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
