class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.46",
      revision: "8ecdf958ab05e59efc73a3df2d7b0110015fd4af"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7462b0ac3a47abd0f183294bd3f2c1a46ac2277380c09db4706cedcc811d0420"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "035ff81d832dfb2667c199fa96a867d1f144531ac4d9bf18d8f2a3de07ade5f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "691c0fc8d12bd83dc9c1aa16c50dc747508f1ffb47ccae2963d8ae77ffa8d21c"
    sha256 cellar: :any_skip_relocation, ventura:        "845bc4b1d50fd128338144b4fe01377d03970bbb4ade37997b9820ee0c0b2035"
    sha256 cellar: :any_skip_relocation, monterey:       "69f90338ab8058599f49104e3a769027184f9ca993ab70a9e1ab2d2408ad5c25"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c84730a524642ed3f4a50529cbebcdfa92bc64ce228fc2c8fc7cf3e88bb4a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcedae62a77f133855682bec0a2d6d0d62d33c1fd7802af89971bd759b605492"
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
