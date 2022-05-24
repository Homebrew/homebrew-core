class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.06",
      revision: "2f846777bbceea307771e79d4452e071b0bd5a51"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7291dd7de6d825311f32ade733e215a02b79a81c8a60fd6e518be13657a6ccfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8228ab3991bed611bec4158bab30fb96e92e0fd0dcb7f2d524e1509f446f89dc"
    sha256 cellar: :any_skip_relocation, monterey:       "5a6bb2d317f12c0afcd92f1831ea01ff23cf58ff3ebd75809c3a99877382b87b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5edfeef0d6d11ada1f390ec1c9349bd6efd81fd4df490fe7ce7fd19b6c90daa"
    sha256 cellar: :any_skip_relocation, catalina:       "09d77a129f38b1783c68ad97fd1e3056140c52e1909e66afbeb0ab39c22b261e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "035044630c752d7380769891702b2a10c34890bf0a549a7c10c4c5e4adc60394"
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
