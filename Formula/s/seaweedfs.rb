class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.85",
      revision: "7d7e06681dd40b3fd48be7d66b179ecdb31218e8"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab282dcfc56cb702265ad33f2c0bca9f43e8c557bff9c74da6de8e50b30dcda4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b9227280b89f33f61e5347a851adb5eb19dc93011b230dc0cfc63b1412a0a30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8edcce1adb3b1990f8db4e9c220a38f8c60d8783b02c85f40b8fd5d7fa7b7d6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7322d9c1f7b56946e9c9cc960ca4f35d30685f5a41ae305baf53bc676f11fcb6"
    sha256 cellar: :any_skip_relocation, ventura:       "69ed5580fe61c1001dcf120ff9499972fc2030625ea3afbdb31dd86d753b64be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "251707a5db33f1daa0cf7f0fb94f6b3080a86ae24591d865343f9ddb9b3c773c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  def post_install
    (var/"seaweedfs").mkpath
  end

  service do
    run [opt_bin/"weed", "server", "-dir=#{var}/seaweedfs", "-s3"]
    keep_alive true
    error_log_path var/"log/seaweedfs.log"
    log_path var/"log/seaweedfs.log"
    working_dir var
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
