class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.36",
      revision: "fad7e1f7cbec0368f4f872154668daa0a7f6ed03"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c469c04245023156493d833322a2718908be46807bde98328aaa4209ec12196"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f629f0109dc823f50a919bd77302087efc468b57d8f7c4e8afd372cdc95f4320"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeff54cf4b8b3213411054e9c5cf3e3cc512a4d14dd3775abe03a23a099ae868"
    sha256 cellar: :any_skip_relocation, ventura:        "516d8a4a3e16211f55d9f0eda8975142901361ac4427d42200a33d501fd10284"
    sha256 cellar: :any_skip_relocation, monterey:       "4eef19fb10dbc0ffbf5eb623f6fab2266f8ee2f8b320a977fb742d76e83a79e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "70b1412aa2f5c372a85c7c3634cb04c4061a41e8f4cc81dd3b8716cbe0b7e62f"
    sha256 cellar: :any_skip_relocation, catalina:       "6621ad1ccd0cc99994de6218380b69d43ea74a75bd1f5c3dc6304165b0ec73ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d009c162a8c58ab58605a3c607f3f5b7f788d56bd6c5f37a2765fec4a9efd78f"
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
