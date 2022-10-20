class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.32",
      revision: "758d70bdc09834066cfd835d0041f38ac77a1d42"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8de141a7c9bf3c2ad0b9d55366fd6fefe18565d51de0d58de78378bf2b8611b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e8e45debd7a7f63ba1319959f9c7fcee5c7d5bc5e00a180c668ecf18d48a63e"
    sha256 cellar: :any_skip_relocation, monterey:       "b0ca7725cd0269e8114e1a6bbdeb58a7ade63d308da3e3a166d6007ee63ddff2"
    sha256 cellar: :any_skip_relocation, big_sur:        "95d99b98f79125ed2a8e38bf1605cd36198b03801d713104c0f16cd2daf057bc"
    sha256 cellar: :any_skip_relocation, catalina:       "9ff4185672693dc9323b25008dd5ecfd417aedc2e07988fd6f1335381c365529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d61f3009e2796b34977e7e3f4cab80a3156d299a6159042dcc4aabf1ee13f787"
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
