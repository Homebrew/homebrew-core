class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.84",
      revision: "5799a20f7149e8fe8e74ce0a03f138df297e0b9c"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "099c96308cf0ee8fbb970dd204171181f84c8f5aae756349d537e05f2e666b6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf5ed80a8278577a78d24a8068d7da64b1d7e4cf888046c05e60106c18140638"
    sha256 cellar: :any_skip_relocation, monterey:       "9496b7e859e06df76a8e24ee66b4154db5876da3f6261f4be71952b18d06149e"
    sha256 cellar: :any_skip_relocation, big_sur:        "929d09049c810000fb9ea68f7b4ccecbc4c4522e66b12471494e28fa5cef57a0"
    sha256 cellar: :any_skip_relocation, catalina:       "7a1d23d8317394dff6dfc3b1f8d61607d286bf1134c67186ad1f39b51cd060c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c5c1f9f1b8a08751b92e6c0c04c2c0b0c3881b4dd7cf0586ac7e64e7d9f9c70"
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
