class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.01",
      revision: "7e15a4abe21e450c6269d75cdc85447ff5b70e1b"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc0ac562b1850bada86027b250fcfcf0162c3672c6d008ce8ee834eed20ea280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "934bf89b50d69c744b27940cc7b4f54f519e59f806b4bcf2058b0d923bd591a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f5aa2cf73f5b50a2b4a39beab9ad5b9f787ec1003409bccd5aa449444118176"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcd84398605687343d083e7a3200fb86dbb44a03513810f11ca57dbcc32e054d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9143a9b84b97a4348151e3d0f4b0ec0aa3bbe250af9c8c2394e630c4c40132b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3fc34fe9acd2eae974b33e3b6674be2d7e083db5b2b71f94a4d49c458294a21"
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
