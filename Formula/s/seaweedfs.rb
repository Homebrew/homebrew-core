class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.70",
      revision: "402014969020cbe56614d9380656200e491addaa"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68d17227630bee43e2b007b5b542692471cf66ee5098f0a5173d802d28b7692b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04b6394e8b2e7d382968c76d98bd17032069f76a81a5e75f6010a7debd0e4305"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca5ef2ab757ed704f236dd8165efdf4e7a06168a258ea42a4e9f8984017cd92b"
    sha256 cellar: :any_skip_relocation, sonoma:         "46c6d0c88dcf34ce0ee6a3b610079869dd18bdc13a76d5059e4616cbb966261d"
    sha256 cellar: :any_skip_relocation, ventura:        "ef62bbea079358d3dfdce42fe5b43d466a2d89b7ae397d07e2c46a872855de37"
    sha256 cellar: :any_skip_relocation, monterey:       "f88c174a35f5069360bb2aaa2dacbf1fa3fc138339d3ceada46c2d6745d7a692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ad1a12a2549c0d60bc459da74881fb936fc0365784684bd050e72d057993d7"
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
