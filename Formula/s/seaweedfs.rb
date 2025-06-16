class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.91",
      revision: "c26299b05a67135636664fbbe57d9328a67288ad"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d28ea1f5fad5adffd8fce2177a61b64f90197a01b5fe7421ed2b7d7c929e31e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50282164a4fe20bde5acf4e4a75dae937c23a4e739863f0762b56b7c7f936f26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9e1058a460fd07b2b83cbf3563226179c3066b8bbe15a24f000467d18707e45"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e976acc2e3da7db8e566f6e2db245c5d577daacebe47f007887c8a0c8690d44"
    sha256 cellar: :any_skip_relocation, ventura:       "7d2e449b47af3663cea098bb5e94bc0818b60e65ec2cbe3afe7534bca825d5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "105f86658ede3a39e0569ec51805182f9f744ebc014dd7fa6994de138c7455db"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  def post_install
    (var/"seaweedfs").mkpath
  end

  service do
    run [opt_bin/"weed", "server", "-dir=#{var}/seaweedfs", "-s3"]
    keep_alive true
    error_log_path var/"log/seaweedfs.log"
    log_path var/"log/seaweedfs.log"
    working_dir var
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
