class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.53",
      revision: "2c4c2f0994604510631920f4d0d9ee817ec29224"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13e48e8c7d876b108ddbcffe412705c872480c8c93057dde9aa002dc81542349"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e67f4cc80bbc4cc3439a6af1b153cd6c7e968d293848baccf2d74272d039dde2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55c2aead244dd10f557bf87feb000be3670bbd6d5885f94cee5575c9dd3b249e"
    sha256 cellar: :any_skip_relocation, ventura:        "411c45e5e5cfc89f62ca962e66d1dd61dfe79e502e29dd8d8d172cdfc52f2529"
    sha256 cellar: :any_skip_relocation, monterey:       "76014cc8be10b641e31e0af2347d89d9a804e85df21fa059d4c94f519aaef986"
    sha256 cellar: :any_skip_relocation, big_sur:        "66762e2bb2252c613251f8dfd030505fb00478d870f1437b8d996d10a662b1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f06a43f567a979b8bc72adc852769970c78605fe8f400eee15f20b8b4de0f40"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
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
