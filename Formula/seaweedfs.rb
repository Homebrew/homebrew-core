class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.02",
      revision: "a4ca3ed1f0c2bcde1d36bb48f81dedc3e1924679"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3977dbaddf302b726e240e4dc5791b354b85132f4eeecfe9e123077feb0b36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6f357aff5a7b91061a65c73700b3bb9c735bb4a07259a6040632400dd494b83"
    sha256 cellar: :any_skip_relocation, monterey:       "798b3f46c89adecc6ca1946fabb7b7915beb2d1099bd012b14481f75745913a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "68cd13c4306ffb2e48ffdfcdb43733bbfbfd10400216f5560870079ebb7a2dd0"
    sha256 cellar: :any_skip_relocation, catalina:       "d86c84656d3aa659fd3020c89117e8630749a2fd972dedefc6d7b7bf2f135a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75650c31f487ef47b53138cc986e3da714b60ad3c71fa135279a13b97947f55a"
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
