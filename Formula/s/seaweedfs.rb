class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  stable do
    url "https://github.com/seaweedfs/seaweedfs.git",
        tag:      "3.62",
        revision: "59b8af99b0aca1b9e88fec7b5f27c7d15e5e8604"

    # patch for http assign logic
    patch do
      url "https://github.com/seaweedfs/seaweedfs/commit/3002087541f2d4447cbccd67c48554b7b86772b1.patch?full_index=1"
      sha256 "4c40a870e51887ef5c9135809c88c00e3b0297a6f40e20cdff42fc57a0980512"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40fcbad9005c0b2caa281bc375f1c8f94c87ad698640c4dd548ce802eac3de91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3be52cf562a9aa5da5834b701decc95782b4d0b8c2d408c6f0ac0210be535f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75ec8254fcd0fecf6160748b00edc228ca728ee7bb21c4ca7f0d0a611985cf9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "79e1d6c7864c61aadef97daf46766121ffdea884dc24980bb03e19e10f83becc"
    sha256 cellar: :any_skip_relocation, ventura:        "070ed55f7b0d5123d9669c1cba6df29140b7608c5abda425f67bbe1801e7375c"
    sha256 cellar: :any_skip_relocation, monterey:       "ce9c9590541b25dbcf9286bdbce526196b7bf40cfd87cfcd6f88b381a001dda9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae8626e946251bd57704de64ba9f790fba111f9fffe92da18c7eeced19fd65e"
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
