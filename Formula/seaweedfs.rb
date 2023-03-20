class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.44",
      revision: "5b43c4bb98c5e2d83dca5414b4c902b668f91ea5"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90127bafeb0acac3ec57eb268aaa6bec1135cffa9c8202a842b81560b21cef8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3211140c63ade5b6c0e665f2007f7ec8bbc7c390a37c1d46b260723fabd1690"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7503215e19f264a38f10e7fd6d7233b2a8870439da2bc700d0794d5070d94666"
    sha256 cellar: :any_skip_relocation, ventura:        "f7ebeb1f552658cd0d05dbeae3e68d49fc5bf27f0e92ce4623915b867fccd18f"
    sha256 cellar: :any_skip_relocation, monterey:       "5af85ede6e2c3f671dd0563bd80479c0e6c2d24ee01f8a7c78966fb175fe87da"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a8e2769bda7c0e2c6ad771d1612d7d16806c00432430baaa4acda94c03dc657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f52229c83314fb9f3e2764ada3e0932cb82e44de25ce906e8f9230f3c76d70f"
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
