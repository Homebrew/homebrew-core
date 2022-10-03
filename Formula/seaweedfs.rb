class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.30",
      revision: "29632d5a34b2b8fba4060642b212ea46a3a09a91"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b2c713f29c428bc0266f4bbbb7981fca750a14b6a8e2be56f1ef8420052a10f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e80e445d2f583ae0a88f2a07ebcc639345d195658528834b71b989fe6ff4a4d3"
    sha256 cellar: :any_skip_relocation, monterey:       "78250a3b132598429398313e1362ff19b799bb83936f1cc1a00c984a0340ce95"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6fea3a136e7713c1c7784a15b3b0fc7d6c57b48e70d94827c26bbaef12dd2cd"
    sha256 cellar: :any_skip_relocation, catalina:       "c488f1abfe505728c210e77bc8f6e363b497396db9b1625e2fbc160dc2efdb9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dbfbd979a6b53dbf526dfd3aeca8254d0662c4e65d619240682cbf60505af96"
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
