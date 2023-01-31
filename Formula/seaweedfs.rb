class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.41",
      revision: "4d71af87f39324b0ff3136947f8e3c58868c3241"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1d44643a8b9170d1302521651447a39aacae01fbff34d15385af2c8c14a306c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd5d747d4e8f05f212d32a7886f0bf9be52feca8df47d88846a24da57c08830b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f5c347f6b1df299c6905662497edb1d93d5314f854da70776cadea025370fb3"
    sha256 cellar: :any_skip_relocation, ventura:        "49d0f96c2a13c1ca47003eb9ffcd88962499cd0878fdfe863e7f5207990d5111"
    sha256 cellar: :any_skip_relocation, monterey:       "ac916cdcd044bd87bc73c2b10b50be01dac491a9ca74c45acca5cca59ec73d9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "66d37d1587bbbf19e57872a151429398eee1fb3d9175955ad656687f2971542a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61169caf655c7caacbf7fa3edb5dd2df3047de1b4c14b3aeebfd4a3e3da7b7e4"
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
