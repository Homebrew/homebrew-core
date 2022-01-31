class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.88",
      revision: "7270067289802307556d117be422a1e5a208f558"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6062d899e74f96a2b9137a16ad8a7844c5e78696c7f97302cb8a13bc5fac37bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57995f5765a6fa4f9973c174be9bcff410b3560a0334a5c14f3e243a9d284f54"
    sha256 cellar: :any_skip_relocation, monterey:       "f784b91688f55b2dd06bb639a0c65c7e0bfe99b0c77fca1ca2308c8e7e850e42"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9f8852c78010b31fd402e444732b32fbd974b1b54665beddfab6917d29747fa"
    sha256 cellar: :any_skip_relocation, catalina:       "c1b7990bc0da08b47c404b39379f613ba58c8b42c08ce060354008ddccba61a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed6e0b406af0af1f46bd32a1fa0b4caa9003160eb86e6d80cf2e64783bafa49a"
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
