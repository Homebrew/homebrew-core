class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.68",
      revision: "a9cd9b0542ef9e2c795baf063d3f7db395ff209b"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15ff8174313096a1ab4674fc48bb0541e3748311cf69711ed0f210876932f47d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe82b0a955e2bba8f6e7f410e11043e34dada91a38b5ab2ab1c2d7c8c91515d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39fed80df640de5294684092c1dd1f5f126cba931c73a1fc54c1147dc955d6ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9bf35128918186a964574cd87e242edd28c2d7893f42dcd5c4cdcb83e0dab5c"
    sha256 cellar: :any_skip_relocation, ventura:        "a17626e8bd68a5cc891d45e99c809bad11a25b1baa6fb9d8c7faa0354db03416"
    sha256 cellar: :any_skip_relocation, monterey:       "1fed1198dc1fabbf1b875f64c58104a394b36b8ed3fb0286a7784e0a89321dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8d6673b0788fbe6375d76b44163065ba16e0a867d77d57f9e44f315a98dfc35"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
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
