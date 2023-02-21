class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.43",
      revision: "3227e4175e2bf8df2ac8aeeff8cf73a819abc5a7"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d67ef716033a6f2082f7f71f516377a2749198a20c92560ba551f9cc604749de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecf028c142f9cd056dc1842a32707e96d0df3817241128b68195aa50f82cb914"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fd9b73fbebfda9cea6d49f33e1eb6c09bd94d1bb8bbfa957ccb910c0490d258"
    sha256 cellar: :any_skip_relocation, ventura:        "faa652372d080cfc73b6736531ba7a6892fe1fae6f3ab4f4f5abb811c0004f77"
    sha256 cellar: :any_skip_relocation, monterey:       "10d4ad624fc9e9a2bb01059a712d25818cf27ee897b17c6dba428f9bd8fa8a3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1ee253c3ff07dbf2fa39aaded44c023eda19ffc3f27f43ba5587518eac95fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4c1497a95de63f431b738131c3a0f05472046fac46ee120bcf94892a90347c6"
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
