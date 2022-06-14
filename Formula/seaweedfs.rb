class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.11",
      revision: "d4ef06cdcf320f8b8b17279586e0738894869eff"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2afe40a5a87135a929892fd6f887f261a6a4e6ea44749702bacbb476ff4b6a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "007f157f4a8186f5cc374abf210df00862cdf614e33d1e1380079431be79f597"
    sha256 cellar: :any_skip_relocation, monterey:       "af1b4ff9e6273fe2233bfa6d11dfb6081147b3e0816161a5c8fc5bb8c3d870ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "65af6af92622292e5d622a6e896b65e9b7ad2ec60cb85ca5b40b9976243ff876"
    sha256 cellar: :any_skip_relocation, catalina:       "33ac5da5f00a17fd59a31e5d17e7daaecebc707a5736d0edb9f8cded207bf7f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f6774e8ad81ea6a6631a4ba0fac33452396a92ae450a8461a9e39a7a9b7f30"
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
