class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.43",
      revision: "6c7f184381e3c4f7908934f4c1d8cb7dcca41894"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac531375430e2c555619f0bb7811359d3189118cbf2ea7f4d708e551cfd73a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1e0090236c5e4c5306b8bd0e0190040abd899b7faf1727e334ba3962dfebca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2064227d6c28789cfa55dfed9cf79531d32c1d60b1fbc2c9124ee6f06b62603c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b3f788a0ddc67228a6f8011a1b1f532b444ab2dd832e97fa7d9538e3002bdc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e101210eecbc7f5914c5e9289b79e5de0c1f69e8ad28ad4389a48c62e93570b"
    sha256 cellar: :any,                 x86_64_linux:  "aef4fefae1bdac7363a9ebdb389d907c0ba2b1d736a9d100e42915c7fb99d092"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
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

    # Upload a test file. Volumes are created lazily, so grow one first.
    system "curl", "-s", "http://localhost:#{master_port}/vol/grow?count=1&replication=000"
    fid = JSON.parse(shell_output("curl -s http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
