class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.98",
      revision: "c6ec5269f4b34d79ab8e13050623501b8befda32"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baf575a0f16e682e79cf52600182765c22b994e9efd7043f99341fc3ddd21b15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd29c76fbcbfc9e4f4f8e2e9de47f6a1c00c4eb2d3b01a998c3209cac130dc8a"
    sha256 cellar: :any_skip_relocation, monterey:       "e502976aafab154defcaecb35916623bf0f41ec826a2b196d4f5d637cbfbb9a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb8cbac0b5bad0c118716c973b58933d355577074de4d54b03d69f5ffab5ae92"
    sha256 cellar: :any_skip_relocation, catalina:       "ee65d6947dfb7b55058c1eed35c266443610eb19beebb0ad0f740810abc8750c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b5f3165750afa9d62e3ed62dada5fefedc4a5028c475a2d8b1f08c2d7783b49"
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
