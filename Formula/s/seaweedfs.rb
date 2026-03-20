class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.17",
      revision: "4a5243886a5ce8fdd5f1c310369415a6d474f67a"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78b232b1f740796317ba70453149484ebc334708767ce3ada244ab72eed02d91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a127961b00abe6c3dfb75669fe12870fe9585b189b07dcbbb63ba1ab780819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aec5107a8c53de6beca28eb13498c46fdb8abeb40da69822cf4865a62f1f60e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a750128b9846f0b43e74465f2e64a3dc9f9c4bce7042a8bf44bb94ce94f05c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32e672187e102445fe8907740d4e7c07dfc35f7256140bad5bad69336f26cd27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d6b81b43b7948b199be09338c28953d8e6ee549eec8e8820be29afba0626345"
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
