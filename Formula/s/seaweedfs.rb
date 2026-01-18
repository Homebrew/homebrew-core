class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.06",
      revision: "ce6e9be66b077fd9fb8414de8df8bfe6f46b7be7"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5553f6bdaff096740a6aad99248270137bc4d61f05c548b528b799f3447e61dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51a53b521f160897cd91aa0d8d2449191ef9050afacd4abc1623a3a924bcdf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1ee7d0e79dd69e8cd7abd34bb4ac7f66171eba08eebd3753f3cebcc3697cdea"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd88fbf23ddc4a46890601e641bfbae3616e45f305ae713ee3052cc245bfa16b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f515302033e893d4de2c483ae693780052c20edce83074abbc2eaae341e2abf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6a406d4cb747a6056071492f149ebb1516ff66b95ddc88e43cb2564e4be1fb"
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
