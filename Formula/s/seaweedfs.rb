class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.67",
      revision: "d3032d1e805ab363242c833d9a61db59b3941f21"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eb0556ff2d4e85432a1d33d03cff7626f611860ad8732738189beb9fa1e9dac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4753f0efaa8264df7f2ffd8fddda8cc5c581a48eda95fe0444c8c1be7fdbce37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d0f05347ac983b07aa362437da910c817249ac9f273a64c9061abfeb93e18cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ae732925744dc2b17f644c8ad2b857394918651744cebdd25d9f8c4fc28d2ae"
    sha256 cellar: :any_skip_relocation, ventura:        "1f0b892a2a9d0fc5c293ea71f58b8c0104e7ec2732dd98d5b2a243a16d3f3bcf"
    sha256 cellar: :any_skip_relocation, monterey:       "c52f315368d448e557dbf345d2a6fd3c6c97e3ff75309ddb53cc6a0cf9f882f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6982c58906f528f9914f38a54420736433947f1a433e0885d08c30c8fdcb895"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
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
