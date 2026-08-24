class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.44",
      revision: "3563738699f29fd1c9efde6fcbf4ba253439cac8"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cee62c46d991cba53697b451e1d0482122e2506e9fc8a874e128a5baa4203c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe9d2563f5416884cddb1dae3a1101d0c22adbdb241c9caac704435eccbdf954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "409f1fce3fd105bf086c1c84dc4e26cbb6c02c5797e6e07a48dc6f74bda74cf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bdd652b460c100b61c594108c5f781c28aecd3433d2353300297a884b9ef774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9afa9d975c63fcd7125713d2fc5287852d89b596d8d8aef151e520ec788d76d"
    sha256 cellar: :any,                 x86_64_linux:  "897832a552a3261ac218f524ee1bb9b5cf44707a5ee84dcf8af0ac05095a5c30"
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
