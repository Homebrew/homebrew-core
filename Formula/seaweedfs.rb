class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.21",
      revision: "7c029b21832682e27bbac5a310323a7aeed6afe9"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c31a197768d34b43ddcab0e32259b72657aa714afaa8d4aec9ac8c6c838a99fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36eb2cb618533e25acbe2ec7547288e25222a646a6f6967273d660341d3ee167"
    sha256 cellar: :any_skip_relocation, monterey:       "7cf88e959d2497c531a7b82b248c02c645316c74ede1877426eb46f198268fb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2ea736c3b6474454db990d286178821b0a5fdefc4e4ac0436ba0ad4e2ca29cb"
    sha256 cellar: :any_skip_relocation, catalina:       "9d161a9b94723f50b5c4f3474f2c70ac8fa624d060c86f08f6c11610f0a2833c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16cb2353705538f1900639492672ae4916c87c25ff34eecbff183f7df94452e1"
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
