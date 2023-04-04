class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.45",
      revision: "422bfaed69399492649f305caf93d6c0793913ad"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "451c29442c9f80e13070a8d4e781b72f2eea7dad96ce52ffc17229d60a587267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a215765a03ccbe4bb0835b226980e41692ac3fbbebf029d9ef8e2974bae7db18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "311f2be8aa73438f5c19b78cd4bfca7d9b809ba07e7b2f80ba772c2da9469b56"
    sha256 cellar: :any_skip_relocation, ventura:        "3c032a4529baae716134a0fa15afb548072ff1d2be73e1fca49ff519cc354007"
    sha256 cellar: :any_skip_relocation, monterey:       "4ec227616568550e298bc2f12a0e0c3860b3f0c7b4db95e5075f6f4120193179"
    sha256 cellar: :any_skip_relocation, big_sur:        "4abb2f5187673a3d10362006563e8f652f1282463b60599ddf6c2fbc1db8a04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27357ee8ea9c7a85479e67def8d3f65c6febfac0b11d40e37910ea846c5f1ece"
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
