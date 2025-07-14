class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.94",
      revision: "24eff93d9a71f54668856e53e9f4214bd91f107e"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb95a569fcb56afad144078903d805183ea7c83dffcb44a087b9faee1af76f18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "847ba67b4934c920d0aad23c79d251e2099bda46ee8233eaffc9ac4ff9bf66e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f1310a65fbea7c7f6f3e3a91db476bd9164d9244bcb0d5586835f1e72e36b9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "72e2bee648e094e2ef7a75fcf67a46bf2e37eca2294eb3676db8c04ddd494510"
    sha256 cellar: :any_skip_relocation, ventura:       "e968ac424fb7751e67fa608d9a3ddbd7dc2ba319d2f58ae5eb477761d009097f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4363b6474c4e16c2e57bf00a63e6b107dfe0d7883f1a69f99ac7159655f47d40"
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
