class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.50",
      revision: "2e351aa96735ab2d1e4c20d0973d0653820b4cd4"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7872e5b28ed1e377d3d3a1b1c45730970e05c2b003981251364652877e4a9f1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbfdd1c24da35d06d4b333ed9f9bba604f985d3cd2f27da9393b095d4037e856"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74f2290697e336dff9128ea8a713d9fa1963475f80e481718474df091a1a17e3"
    sha256 cellar: :any_skip_relocation, ventura:        "2ac3e406e8fb5704918ee15d68778d3f17cbdaae26bbde40eb62ad5a95889fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "e1202954d26837840181b48b378fe0448afe4b054c813bd4ce59a283fcb853ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "032467d8dbbc91ade8f6e2380646e28ef7701a6c281f7f7cde7aa1018d953776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5cb1020133ffca2ffe376ad0348d39ae0a7104f409ff952788c57802dcd141a"
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
