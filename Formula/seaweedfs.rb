class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.20",
      revision: "0854171d228951b002efd72076c267f852f2cb15"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13ed674435376c71f3526bda2cdedfc665de72e0629967e71a923508168f9819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91ffa51e503123ad251036ab6ee15545f3f28ee9756ed203c614f022dc49348b"
    sha256 cellar: :any_skip_relocation, monterey:       "189f781f8d5628d257beda9b038a68d953d0297532308fac8245f6a72a837050"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0f60bf1a79e554fb30fd34239f6c5aa2f2260d143bf928fd4dad0180f5e5d47"
    sha256 cellar: :any_skip_relocation, catalina:       "405ddc4a14caf89ec752e1ee312ed1456b83e9bf5f7b0427c98bed1f1ed3a5f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "905fc283b54f6f8a376653e7fea98c60634c2e0deb194d90882bf05b3d78ccef"
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
