class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.11",
      revision: "d4ef06cdcf320f8b8b17279586e0738894869eff"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a37a4d56020e23597d01f338d9dfc49879c3c7e42533925435bb58f7cf818c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0429f3b04e5fbe8a99552f81805b70357eb3a298d963d5b0ed92a4dd6042780"
    sha256 cellar: :any_skip_relocation, monterey:       "59eeb49a5e64f01568f72cf6ed311e987ec6ee3f7f22154fefdec9ae718507dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e84f014684b85a1b1492a803b158f654a2259f00c1c5fea59455e4b96972c06f"
    sha256 cellar: :any_skip_relocation, catalina:       "ad25d2f69071e515269031cadd7b73be7edabf1594a0350da4e72a06c1af2eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c462e2f85e2cfad39a07544fecb3a4d4a77fb4c5b64390b0f0b4dbd4ba9880"
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
