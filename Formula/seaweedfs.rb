class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.12",
      revision: "4dc27e1ed598b1c1aa4facae856da1f71df00ea1"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "709a934df456cb01b1adef21c5ffea0e907565d76993f668062525c7e0c37fa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62c3e49f265b0b6f824105a50ff7b9620390484e4b7158786dcfa25ecc80ba1e"
    sha256 cellar: :any_skip_relocation, monterey:       "c84c532404e9137f6e74e7cf46908d7702c9684f2085d6d8d649d75218b24c10"
    sha256 cellar: :any_skip_relocation, big_sur:        "8af4eb640e7d26b5568bc4742fb1082939b54990e34ec77d6b5ce6e54be26998"
    sha256 cellar: :any_skip_relocation, catalina:       "a5f26f22d9856580e69f629f5d19eeabf4f6320f0a29cd9f483bbf3d3656a02a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86154838782658a19c26ecb00d6147389f91969921db1a6bae05e6bd1809598c"
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
