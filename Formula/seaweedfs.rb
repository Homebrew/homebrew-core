class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.16",
      revision: "56ec89625a5d4a66e3b1c810544afd93f449842e"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd542091f847ffa9fa1d97237a722d4f12d83d5935c7efc1267943eb9b106ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68292ba93ae49b028f0608e69cad471081f6b4834dcea154abbbc80c799d399c"
    sha256 cellar: :any_skip_relocation, monterey:       "d8aa854580c2c19e5187ee9932107e898b7a50e9794a565be9e579da248c7f7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0f75d49d13e31e96d09ba97df1b995ef2bed5cdbde55930f43f5d4839eea5c3"
    sha256 cellar: :any_skip_relocation, catalina:       "5b242d09a438c36417b042536bda897f98d3b9a8ff873845913768650f3baa0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "752859a133fc247cc90c2b17f73844810fb61bd21894102235a086682eb7f94f"
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
