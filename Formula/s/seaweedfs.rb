class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.88",
      revision: "6677f1f5639b8994f0fbe11a1bf991e9f88fa1da"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8f6ff930aaf2246c9e0110a7626004ac702992bd48e6890497aaebd7c10425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9202755f9fdd2e28b915f164adc6a9d12972076c52b8defff83107246b5a0dd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dda2c85d934ec3ff296922a428d3f42392fd0ef9496d8d8eb5467bff1e9f1dde"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e37604784a02de1fc141e753f425f539c1f58e9cf2a6e18d6d4e42395342470"
    sha256 cellar: :any_skip_relocation, ventura:       "84b7be0f856a2bf2508729d532716d4ab6d1e2ef0231a838eb7b9aec61c96b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0d157eb8368daf33b5176d49ae9a593d5a1710946cab4537b6c54d64caf24a8"
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
