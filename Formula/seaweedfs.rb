class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.85",
      revision: "19555385f7b99bce0e1f562f3cd4a4f440dd3d8e"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b16ede089b42ad8c28fef31be6f4062bd0338eccc45f3eabdcab8eba944a28af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45db291e532c9b8e78fbcc2069c641c936823bca000f377d79629634f06d4465"
    sha256 cellar: :any_skip_relocation, monterey:       "35c87710a4f8b4fa5e15424383b425b224169f226c0398c1aa89c2e8855fd98b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d8e0af647a835272d589dc205bb0fd71498eafe21afc79779bef5d8a59546b2"
    sha256 cellar: :any_skip_relocation, catalina:       "3e4c15b4c6add9058185c8af8d99fd68f92310c8c22c8b52ec2eb36d81e70c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bd0ab4e4002e1b1a0017adfac84d55381af61ef133d5187d960036a0bce119c"
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
