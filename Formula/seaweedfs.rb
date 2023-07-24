class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
    tag:      "3.55",
    revision: "7eafa3420b8e5ae83c8873cddd03ded90a0fc921"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc8522990d95add5cf71ea9fcdf05715efcecf5890332552c42476a48cf6452e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a2d9e24a3dce480dc9f734290fe8c3f55e7da24b30324951601a7b3e508c1d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc100783b15d77c81cc6f29bd4af625a10a312005473fbc93055349359508415"
    sha256 cellar: :any_skip_relocation, ventura:        "c6a450804ae08bb1190407e6b2743d53a3c1dcfcff611591df1f33ed915b0edc"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1d78c939f2073223ed2ac3ac54902ff2889a841309ad83937a5bc038b235be"
    sha256 cellar: :any_skip_relocation, big_sur:        "14e1cd2989c9478d9dcf47a6789233aa4693aaf7f279ab6a6eda3e0154ae00f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bd50b94739eb518418b9388ebed8c65830fc89cda0dd1d0b872a07756195fd8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
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
