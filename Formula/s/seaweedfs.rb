class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.00",
      revision: "20a2e672d2847c4a2a53ff9676d08ce91600536c"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a9ad92e8a1101404cd13396ba179de66d34a203fbca1ef9e83b35e3a6adfec1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f1851fe52094b5d049c7f492ed4a1e6d76ac91e1fec61c0d866999af77aca52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f52d09f328b1085672b9419c8b39f95a81293efa4cd05e8e6ca200949f78d171"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dd0e28d7a8161470b6e2b316ed3815ceabc840cb2458bc2cd7996b84124af94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0d31e1a5ee5983069fb6b1a8c2bbe8cfc95ea6f1bdd78e0775202c24b934b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5abe9df4ce15e71d5fe592cee55c120c09700704d4d3962d2bf5b83fb4115edf"
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
