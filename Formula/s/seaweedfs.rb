class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.25",
      revision: "7acba59a5c9a09ab154d218cf90742dd1b962ff4"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cad8696b823772c1151c692d812509daffb4fe16c56155422c8fb08fba3db06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f83e2259b87fa45725e49b33614c1f436f1fc9cab66cd88a3eb4237c74c349a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60abece212410c37cd2074d8cf59cb641e30a69e69485dfdf1186d412f12ea64"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ddbb2acbf94ce07e687636baa5367f3f47c12511aceec7290ed519d0c080536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f42d157b1f95480de59e8cffd56ee218d34fe04627065dfcff27c4c4ffb201b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b69e60a72992c91a37083e36c77c7cd274cebbd164b3f54905eabfcc242389ab"
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
