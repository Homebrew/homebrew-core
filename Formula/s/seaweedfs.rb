class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.63",
      revision: "54d7748a4a54d94a31ce04d05db801faeff4f690"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39938ec6cd749243c5b35c58c055d6b9e0817222a21e31cb3ff18a03918af255"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83345ad168277df4705e64e2c0fb3508627dad399c341725f93f7127e75f33e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "660da565de672e490ab0988c6a6a4473035427cc399e2f323e6303e43d11a238"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad4125a03bd8c6c2d2de31d6aae89827d880cb860aaaf54804ac03dee25eceac"
    sha256 cellar: :any_skip_relocation, ventura:        "6aa71c06cd4eb035262f278c3145645f73afabc21314baf3564e0459cd726551"
    sha256 cellar: :any_skip_relocation, monterey:       "6f986f806d7a3d58385dd4bbcb247169aa90500e1db27eea5c21d89924a3ae12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b27cdcd60eb711ce07a3cc42d09b6837f45f1e577502a8065ad5bd0b9d62c3e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"weed", ldflags:), "./weed"
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
