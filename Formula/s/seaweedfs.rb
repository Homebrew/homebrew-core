class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.19",
      revision: "0bdf9b06831169ea77fc13b2c11c063bc1e8e946"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d448fe90d8288611b3ce38fb614bb5b6eaae5a519701acaf3563aacc8d345ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae1fef5956ed41675f430852127cbe53ec6c09eac5bff4ff1a0772863a6e1ab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10517a54f66b1c54fd6d7bf8658fbd2e18537cf7a6c2b345e782c2e13fbf73d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "514b93cd45f339f6aa586053b95a4b2e758328c8328213359a2d1efed5125325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba4b0d93710c2773238a12ef5d21ea3a01ada12286c445b6afe05fc61efdbf4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d4c06bb4910ca18296aac7cd36a78823d409212e04344ea3c3738838a335d1c"
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

    spawn bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
          "-master.port=#{master_port}", "-volume.port=#{volume_port}",
          "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
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
