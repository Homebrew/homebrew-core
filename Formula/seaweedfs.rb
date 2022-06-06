class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.09",
      revision: "4a046e4de7a40730895f8149120ce8d6e95f961d"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7c884b4480db834bca5876d284e1042dc6239f95b3217389feb936992c618e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2be1e51a1be09953e56f07b59bb0c971690a67b2d726dd2f316fe6aee937af50"
    sha256 cellar: :any_skip_relocation, monterey:       "f961b99cd765bee8fb9126105c886a4132f21d7a41f636c30ca8610294f8a1f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d04897a6f2fb8c77458521802bd08f8c14e3d61f6e11486b9b95645591649115"
    sha256 cellar: :any_skip_relocation, catalina:       "963a4aa82354616aafeb90c699459b5a15526571f7d03d01a1840d0bf984ba61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c2e5203f7705167ac63aa3b938c60fb8fdbf7afb45b36a7122c340b4cec829b"
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
