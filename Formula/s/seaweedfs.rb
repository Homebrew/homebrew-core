class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.77",
      revision: "b28b1a34025a2f2ed80883e245250d00783bfea7"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b4cc5515aa6b02228ee682ea71d01f2b2db01079b24ec1a6e6f552938dcceaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cb22612af522c6a0ae6887caed352b37824f13724633aa51d73bf1bafa8f482"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f4e3a1f44c88fd0cabe889381d2bd0cbe420e1c01eff9bd60a7052bb0b9b8ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "942b94606031c1d40c6ef9803b5871d05bbc65059e90fbe333ff8695ee55fc33"
    sha256 cellar: :any_skip_relocation, ventura:       "2ffe6830ed3f11c9eedaae7762be539b8693eee92372428e15da9ac9a810a7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afaa282132a80bd7ea2d3c14b1e08b771dd1c58e537e4cbfa4067789e7507dc1"
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
