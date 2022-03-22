class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.95",
      revision: "8f0410af2c01e158e85a635e3d6725ac6b966e1f"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5fbd4c3892fc8d89c2d3b7f4de50acd58215382649b83613268b66afd9262d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8da263c0c20d845e92d97e3b83f256471a68e193b17bef878e771eabf8780af0"
    sha256 cellar: :any_skip_relocation, monterey:       "778c04cab3a3e043d2b51f6c534f67c31c647f8b0ccc627769dbab55608a1e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "2495fe2524840243d369828303a87dfdc8647d12a7e0db946bbeefcffc72a2cc"
    sha256 cellar: :any_skip_relocation, catalina:       "f961a53d7149595928c6bcf068967d89378ae6cc390f9eb437e76313a75e7c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca71efe4fb9c34b298481e4a3c0ffa2165ea3406ce51dce1af88da26da8ffc42"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chrislusf/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"weed", ldflags: ldflags), "./weed"
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
