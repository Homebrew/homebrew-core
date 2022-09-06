class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.26",
      revision: "c07ab9c060eafe26cc0b4246d507d5b33f32f317"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d9e6a6e0cf9888b3f6eb2f8838b714c9345dba6354da03337b4636b0598e35a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0eb03d58213969c99c490d1656d908e13369df592f2726c2c6774658f46fa7e"
    sha256 cellar: :any_skip_relocation, monterey:       "fb172e90f268e0de691b193fda6a83a043119a97ac1e6c6381447efa607b94f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c277b931acb2b2435d986456756edc339f27ae5afedc342065d212689697bd82"
    sha256 cellar: :any_skip_relocation, catalina:       "e3fa9d8f30a6785340e392908737555983014420499cbee3f61feeccab7b274b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccc024aafbe7fcb7a6d72154061012b2a9162851f738b916e8a40118def0978d"
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
