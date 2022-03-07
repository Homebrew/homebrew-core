class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.93",
      revision: "0ba4e4cd23cc50759e5d5a0bd74e177ed7f80070"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c5a54d66dbf71d19b26451f56847f16ca4d13a4543e64271a8ca5a38775234a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0abd55ae078279bdd6a25ca94afcd55141de49432bc910dab3aeb1069d02780d"
    sha256 cellar: :any_skip_relocation, monterey:       "cfdd185ec1538b0b8816ee7331099896b40fbfd6ada505d49ba10a3baf6e373f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a73ea4c5f1e98828fd238aed0f91f2a9dc1565459ff8baa038c219e5144ea505"
    sha256 cellar: :any_skip_relocation, catalina:       "58cd98d0fcdad35d2f049be81907de3b3a4079d4f64b5e01f35f2109d85e5cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79808b0f71e05bb18879fee9132eb557a74980ce1fd9df3dde909bb81ace9dd4"
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
      exec bin/"weed", "server", "-dir=#{testpath}",
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
