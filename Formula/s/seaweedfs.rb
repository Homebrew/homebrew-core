class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.13",
      revision: "63f641a6c9e6ee7e1fec417cabba4edf88cebc53"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dca34ccf309415d2da1e6d8e866be54e8fea03cb8436fa89b88b10e02ebb23e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9965d3297e8131f563ee8aa9e37e1b9241b898e68d928ec8ac7be26cb44b69eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b21d919758c2e8e958dac883781209267048b866ee62190be1d68121aadccfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e023a3dbdff3656fabade5c3626daf306b820ce3d7cb3a1ddd96112a9b31162c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96e35a9e88e17637771f191a8f0348ded60098aa11144644ac0ae8df911e021d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bffb2b6faff7a9450f6bdb5747876213074672d4dc56675114e888d65cf1f12d"
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
