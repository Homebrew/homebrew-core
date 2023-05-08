class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.49",
      revision: "59f55c1a661516033e05f6cc306cdb92e885117c"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1ee4e1b4fd8f42add24233da6bd7353a83b71fe14c9eb1b576a1eb4168377d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b02876bdc36a4aa05358a6787a11a71013b9f5f0cfad5330c8dbca90818d20b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "311268632b3ebd2b3f4ae6de22dffc159d6310baf64d5a6ea99779193a462738"
    sha256 cellar: :any_skip_relocation, ventura:        "452c5e8a358a925cfad2c9e0e760ea32f4fc1db06968b7bbd6928bbe3c4f4d08"
    sha256 cellar: :any_skip_relocation, monterey:       "49e44428a617cd0fd5c12af1f9000cc0a26d838ad987e51431b19289269a5d87"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4d5063a76adf395a923702d06139a1cbe0bf618c044c30f1ad40c79d3861c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa48f8a2511aae0da443b2292ae1547548801b54682fbd56e90e2c7393c4ad15"
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
