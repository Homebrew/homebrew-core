class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.38",
      revision: "48f2edc06503d9a915fe8eb4cecbfc83f1467ce9"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1375a4592da70537694a19f603458530ce8e0158e16e61158a1a06013932786"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b0b27d238ccaf03ff74f925a5eda4f74896aaa5a3801f9736645f1807d5ee95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc5532c877ff6ab89b1a6450e74573f56df00aa9cacdac8cce408e4e079647a9"
    sha256 cellar: :any_skip_relocation, ventura:        "62c94146323a1d84166d3ef6c386423ac0844b8ce3d19229dfa6f3b6a3ceec7d"
    sha256 cellar: :any_skip_relocation, monterey:       "c5d853e105407f3484eb362d7d9a29a0e2516db132c29cc931c46f7776117eeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "25e04f190e0349a7a26812807d859b59fbdf1ca3eda92a3557dbe4673abc24a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fba1295bf60930a0fc9d78a3dc1eab1e25e4866ffea6167049fdb1f55d0d088"
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
