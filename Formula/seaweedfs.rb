class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.90",
      revision: "497ebbbd45cb1a095b4d061258871ce63c706e61"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3223f357bfd12ae63719d576e4d6be0389e0ea3e5c0294eabcece973fabb5fe1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0b61916ab4537d4c298fa9471fa3674a5f122b34c581a798604989a1081407c"
    sha256 cellar: :any_skip_relocation, monterey:       "3feeebf03dfd6c1fcab927e8bfd5ad361ede72a476f607a8ffb0b1eb941579b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "542875c59f8f58fb936380f52e4e6547713ebd10eb9ccb705d14c4c862b2145d"
    sha256 cellar: :any_skip_relocation, catalina:       "22d72c4974dc06a42ab8a4c09b8f55bddc604dfafe9ca67fd84620e74f1521d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a85c16bb51c9571f44e62ce33184f4b0df270f71239c7c8934658e7b8cddbecd"
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
      exec bin/"weed", "server", "-dir=#{testpath}",
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
