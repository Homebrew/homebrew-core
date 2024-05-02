class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.65",
      revision: "0edc5aad9a489d0c99213a45e27654703fa5da70"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "493c9f32e83f02e4cd2b9d6dba5eaaf4f6d812ebb98b15ae1e455d8f8f074ac0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "762a6bd5156423540189ee285e1919f587b7e9d40d86ad3a3f05046e7a942d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "811633493ff8a00000f42bda4b5f6ed8c5aaf4900c77a6de5cc15e9590984201"
    sha256 cellar: :any_skip_relocation, sonoma:         "724754782ae3ada5ed86d9b1b2fe5a67e0aff79088e3aaa7a6fdb3dad110d522"
    sha256 cellar: :any_skip_relocation, ventura:        "2a46144005525ab1ad12c1a5f4fe9e5a4f9d1c6d2ceaa26db8e5b47cafe934be"
    sha256 cellar: :any_skip_relocation, monterey:       "ed6a98c57ba6e7536da9781898a02843a798a313e576c3e1faf34b0cb5ac0404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b56ca17d557d4e02aa100032ba0013115fa8b659de46bb51e391685d62c0b144"
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
