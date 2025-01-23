class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.82",
      revision: "ca4dca14d8b92bc193477f1b97d95fb440f21b43"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcf185b7050d1a260640d4e921dd0541fbb8b505d1d62d96815707eef63ab99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ef1776bd18150989bfa0e54e074c786b614bddf0bed3b0e3254d4d5ef1d7d75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a104e697a9589c36d5aa6c21ad1d6a39718eb0828b720819142491f80b9de13"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa3cbf90c61ef103fc4cdfe9a137c02ba6bfd58df5a4e24aa3c26736dac5935"
    sha256 cellar: :any_skip_relocation, ventura:       "538e4dc719031ae9e0d83e7b61f868124ba947508d3f66424ff2b79d8f140e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4e55285447ef3f4ab2cb68dd9c6ea9804fcea89878165038b80007beee0e051"
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
