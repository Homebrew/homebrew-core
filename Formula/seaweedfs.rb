class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.94",
      revision: "2eda3a686ffc1707e67a45ff39c5852f02e5ec7b"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db868d35d02d3a1492b42bdd825a8d1ccbe1b37755a4b060f330732da656f66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c0a6c2cca764bd45075557fe8ce7e7beeee923a465313e2e0b14cf4afbc6d14"
    sha256 cellar: :any_skip_relocation, monterey:       "2dc7f6c3026069fdc088de21fa238a040c07ea70246ba002173661e455f7e8db"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce4acb5947e40440c6e37d04bf786bd890c1ea6d9d7c09e38942703cc53ab48e"
    sha256 cellar: :any_skip_relocation, catalina:       "d3574ad6ab2ca7186393e0f9608cd4e0eac1f184eec09f0f29c8925104e2c059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c6a4a79153d2d161adcba6de2932e65d4588fc8018b8a2ce20afc30b7662d25"
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
