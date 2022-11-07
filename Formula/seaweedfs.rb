class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.34",
      revision: "47db75a695e7318dc1f98e4c1e014dfe7843282d"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a1d9f8036fa1b77d04587bc644a87a13a93f6a84fc47e57b9f4cef83e35b02d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3277d0809294fb953133d1d7611434f20790540dbf290919cbac82039b34777"
    sha256 cellar: :any_skip_relocation, monterey:       "4f45deea41fca7dc6bacc8d3987146ee3c3c1a87c4c407744c885c3adf62c195"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba202f6b2fc0a81340e18bde6060007e78b99580bb792f178fca2491fe93b575"
    sha256 cellar: :any_skip_relocation, catalina:       "90537803d34328fa790ddce26ced8d6b20d8881856997622621e7c43f4c9b420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f50ebdecc3837159d3fc874a50748295a1d632e7253cd93139bb20d93cf292ea"
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
