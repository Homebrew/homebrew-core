class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.31",
      revision: "0711870f43e6c5eadd3df70f22478e6e9998e5a2"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0df6a5321465fb5f56fc735b202a055faaa35164e387b036071f76691dedaaaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00f2b44863cd31bc8fd83ce582af7d1a821e6e08b8744fe3bea02d13f7f1cabc"
    sha256 cellar: :any_skip_relocation, monterey:       "4852d967e2bacf2086f0de96c4b908b8fa7a993231bd61bbf11e950866562707"
    sha256 cellar: :any_skip_relocation, big_sur:        "f547431cbbd326b38162c5b5ccc546b69999ce24fb17c98d724624c5846531e5"
    sha256 cellar: :any_skip_relocation, catalina:       "24772efd1c99fc281bf4355be37fa00302591f392e02572207bd98225eaee9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5011299ff4fad35dce303269e8e87242f2aad7eef1c6e85a37fd60d5f697179d"
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
