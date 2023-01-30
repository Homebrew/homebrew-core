class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.41",
      revision: "4d71af87f39324b0ff3136947f8e3c58868c3241"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1325d33eea3d4a42ad3685ecd3296ce925a9347fd82d6b8eff325ee1a2c8e63e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef0cccc997c0bc2e12070afb2582354dd78cd21e7cc9a6d4482959693e5a7dd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dc8d83723418609d7d8b2c876556b22c7bf49b9471c110447378c6015845c23"
    sha256 cellar: :any_skip_relocation, ventura:        "61e28ac0578cd5ca6ce26511d4945c775b4eb4f7cf2feed1c1b233cea3874e53"
    sha256 cellar: :any_skip_relocation, monterey:       "138d2932e5be1c71566c589e6bd35b24485c05a5566b7bf1cd2ffa8938a20ae9"
    sha256 cellar: :any_skip_relocation, big_sur:        "715658c012d5dca55c5c5af0af1940b455bfbe6b2cb52852b0d26f8557a6463f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d7d5c03446128e26dffad73b92574040b1d95259e7bd6458bbf313f2d0d9f27"
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
