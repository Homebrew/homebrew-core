class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.90",
      revision: "497ebbbd45cb1a095b4d061258871ce63c706e61"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfb33822d76ea0cfe60c5e010de0804d4d9093c9d8e2afdd0092390cf5f981b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "745b84a8c96ef45e5c058bac3be35b2dbb0287004064ae1d7353830dbc9766ba"
    sha256 cellar: :any_skip_relocation, monterey:       "11cdf8664626dddc4c1389dd3fd9f63a7f9415b8491e408936a4d895e86a1ee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5e77db4a17abcb7e9b61e3406cd6476c805874d140ade89c25befc7e737bbda"
    sha256 cellar: :any_skip_relocation, catalina:       "1591614e42d5ea10bd3eda69ff9c91e7da06d50cb248e88dc7ff68b0963f51fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e87c126065646fff87aa5bb3295a29f3ab72df75d0c252c7596eeaba12faf3f1"
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
      exec bin/"weed", "server", "-dir=#{testpath}",
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
