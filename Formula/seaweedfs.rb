class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.98",
      revision: "c6ec5269f4b34d79ab8e13050623501b8befda32"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fc3d17551d7c11a520447f04906686b06cf71c2f0764052d4f40bc87ef49bb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef003c5950c6a772c81fa0adf1253abeee8815ed3c5031ff80376833373c170d"
    sha256 cellar: :any_skip_relocation, monterey:       "0703247be61cc22a80345dea061df28932f4a1815dcaa63b0b5d109f411a56ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "a508e118386c3d80b34b89317c7023c64067d3d06d8f3cc4da258befbdf5cbc7"
    sha256 cellar: :any_skip_relocation, catalina:       "33a3fb158fdb39796cfcbf0b2f0ac783d46d031bc42c0dd10dda73ceb247ddad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37859e05c931d600539cf0fbf9218363c8464ae6b34d39fc267d514f624ec5b4"
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
