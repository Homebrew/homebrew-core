class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.64",
      revision: "b74e8082bac408138be99e128b8c28fd19eca7a6"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8a69b195f40c920702d981eadbcde48d97eb5e01d2c69dd806bf3267c566749"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59469c49f2e624a54a7ebd3ea4ce45bbc903a9457ca767e3ee4663fa5eb7ccda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f00aad459685a4db218a1a6401cac9f8c7f82cbec44b3d6573dbe0dc4e24cd47"
    sha256 cellar: :any_skip_relocation, sonoma:         "dae53aefd42791efe4c8198fcb7b3218a0e27b1d46a17d803029086850f4389f"
    sha256 cellar: :any_skip_relocation, ventura:        "89d38a0a99601cba4320f2d825db704f1188c8c4ee8af8196857a0da836dceed"
    sha256 cellar: :any_skip_relocation, monterey:       "5dada3c30a233e6c625e689df393015e17f7119bea8516f6cf04b9ea35049c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab70ed24f44566bba916932dbd6c37519aef31a31aaeb50290a2abf804092489"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"weed", ldflags:), "./weed"
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
