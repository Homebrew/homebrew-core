class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.25",
      revision: "5b38f22e6ea2a27681d77b42c0d09620ae8d6966"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d6422aa9fa6a94f87a6e968df5527f350ca104467a0983f1ee8dedbfd35a0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "498260921131074f4e33ba150ad1e78fad54b9e3c05c9ddc29ee1bd75317e8c6"
    sha256 cellar: :any_skip_relocation, monterey:       "16d360801552e7b8ca2826fb315979c4cf62fa8fb021b3961f5e8854c111c25c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ccad3ce2588165578134cf982b473f05c33896a6ba8d07c420e4bf38952b4eb"
    sha256 cellar: :any_skip_relocation, catalina:       "005adcc469de842efed974f27f4ed590025fa8a1641c16ca10756a7f6221cad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30c1cd74b95ed6f4e2203f13dd34d220a00f6e2bd98f58ca56bb2efd28803049"
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
