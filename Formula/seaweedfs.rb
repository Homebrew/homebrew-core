class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.01",
      revision: "73961e24d8b311b938dfb692f93e172866813487"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de297aa08210a393668c87ab0b556f31f410560cf875564500d08b5dc617fc06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "985ac89c51fc49b91c5e2b0540d45e7341583d325ebcfe81273843a596af4f60"
    sha256 cellar: :any_skip_relocation, monterey:       "74e5ab7b7226bf299ab4e77d5e915f0785e2001768375209b904d28ff426ed2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "59301197538fd3f4ab2e6fc1ea88fdb0363de7db71f8cfecae5b1afa15f822a4"
    sha256 cellar: :any_skip_relocation, catalina:       "822da4cba94c6a8b077aed425281e4db19dddd4544659d60e887739026af0251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3353150e478dcdd600fa3954f333d50dcdb8300b5b2cedb884581848e30ecf07"
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
