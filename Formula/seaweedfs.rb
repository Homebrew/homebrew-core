class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.04",
      revision: "9ff0d9900288a2dc92d3a82256fb3f359be20d3b"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "697293ce0a6a1e673894690e54c79498051dda6c94638299ebc42f4199e8333f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d1bed055ffe94b36d0be3986b786680f7b77179b8eff7c6b31d7198711d0d4c"
    sha256 cellar: :any_skip_relocation, monterey:       "7089bcb3bb3f011585557b53b27ec102d8224bd057bbc8326b4500fdfc09e66e"
    sha256 cellar: :any_skip_relocation, big_sur:        "52fa07c585d45a340341a8a6c14020e3fd8fe2117831ac3749955afc94a56e26"
    sha256 cellar: :any_skip_relocation, catalina:       "7a760dc098f256efa3f9fdc42385ea5e9cfe2d3daf8f7f98ab562a7356395ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b30d7101d28db0c50fa37ff52fd593ba474ac5bdeed107af745454a97be42f7a"
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
