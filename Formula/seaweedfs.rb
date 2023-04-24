class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.47",
      revision: "18686b7375cb02e6a3cda9d2f80387009c21826f"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd45e6a505f0dc9dcb8f2ab993963adea183d79ea5f727d7234f1915ec7ac106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27800cfdca37d880ab89f62c361c2a22f81b7d8ac134ff2c337b7b8dcca97bdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9deb0e0784b6ac7c9f09b519a186f54ea42e2f0b7d901f6b5ba810b4bd143153"
    sha256 cellar: :any_skip_relocation, ventura:        "072a934ed20b1164d45e34f6774e311acc9ff94a0d3b1e118f514fb221239eb2"
    sha256 cellar: :any_skip_relocation, monterey:       "88ae80f24e6276d3bb20162554ca1174edccca57d20dddf5dfd3f57009b90be8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a198511f3b7ddd2aae499f1d3f75bf17c9c2657da9a2216d3942b9509d02e3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a728b2e5b82a8cd76db037d0645a7a590ec7e3e6088c5c1ec8fd617b326033"
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
