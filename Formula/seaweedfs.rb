class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.83",
      revision: "c935b9669e6b18a07c28939b1bd839552e7d2cf5"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e63c6475cb7f0c8d4ece265202a411df77e18780e6918312c15d267e4777c3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "526188b0256a1919a4de0b929f00aaaea9574b9bccc45c658544133504c0e89a"
    sha256 cellar: :any_skip_relocation, monterey:       "fe4fd25dff32d0adc789de82ac523d1beb3cb61342e6f0e552d55b84a988dec4"
    sha256 cellar: :any_skip_relocation, big_sur:        "71044ecf0aef141a4027423afb46428535cef13a563286cec4b11f4ca855a2cc"
    sha256 cellar: :any_skip_relocation, catalina:       "ef602ee8f0724d479b973a03a6109691fb1b499c8cd25cd0b7eda30e426cb246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be0237b19da00f809a3aebb8e40aa433ff88b54b574b4f1fed5bb45c4d89620"
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
