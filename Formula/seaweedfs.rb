class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.92",
      revision: "ba14307319a9813264154b19ff71f2bfb041fbac"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f309510872aecd0484eb00bc36079c1c25409febdd186f31952d51fdfabe06ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bece944f74b43bf6c12ab82b8335ff760faaece05450cd71d4eead64c67a33bf"
    sha256 cellar: :any_skip_relocation, monterey:       "7c7bf27808f58fdc275cfb9346305055b61c6e023750194d25afc33e5df57a80"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e235bfa57c833cdb39d6b59af66ee810bb34717b2bb18dc3d8bbfc58e4bd17f"
    sha256 cellar: :any_skip_relocation, catalina:       "473d5ae9de8f417d68a2269c9fe7bf11c9afe93fcc5abf1c3f59e9372752e61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "805d3591e5f244ec39772224959ea9497e52289a8e187d7f11f001b0832253ef"
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
