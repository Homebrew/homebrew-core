class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.09",
      revision: "4a046e4de7a40730895f8149120ce8d6e95f961d"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8f653238e6b7f673319795705aa89408c8209571a4d1c409d3ec1043f73400a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0c240066c8519b275f1becb1f439d8ef0a8878a992f6dc470adc19e7c51a855"
    sha256 cellar: :any_skip_relocation, monterey:       "d6b063ddbc3be6ecd4aef7c48d9d803c636ad252131da9627aa26c9c458cb0de"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9ecae67504b6e42e066a9fcda26f305673c41f065b662acd9b0a9d1ca048d82"
    sha256 cellar: :any_skip_relocation, catalina:       "b1a3d057037cbc67d1678c3226703eb95fb44a6d4904b8e0373103c60944da73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f23cb529c418b65e2f63d567d6bae50eaa015d549f0093b2e2af0cc432671a5"
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
