class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "v3.33",
      revision: "0f360862bfac3bcd481ff63f46c8b0ac7ec869ba"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afd5426276c822d1b18816ed2ef57f5debe44e5361957b50c6dc21903f8ce0de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88daafa3549394e0153c4676d171ed73f1938603edfb474b2b4250a0370fb555"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c5386433e25d70f15fb1e72665694340177ee6f83bdbe33833ef42d1ee1560"
    sha256 cellar: :any_skip_relocation, big_sur:        "6223a3e71a30098281f7b49d3f24af4735f7763a86c0f14302c25e7aebaafff9"
    sha256 cellar: :any_skip_relocation, catalina:       "cbf30e73b10b5d342fa5f1d074be13cd6e9374b44cd812635f5ee830aae34e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f9ca28d6b6ddfedc2414dbc8ad0316c674afa5cf92df191f19ae8550a1a025"
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
