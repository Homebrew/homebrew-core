class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.87",
      revision: "e185d90d24c99bbcb502f729c3b4f8bdf7b7037c"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba9b24265eb0c2db6cede8d332d4527c0bc79970c0638640b33e2251c660ab5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f152888046fb3368a4142a6420af01c3e17dc65384069ad4e141db8f78e0b5ee"
    sha256 cellar: :any_skip_relocation, monterey:       "706478289c9497421aa29d5e2722ac6ca27acdf2dcf44f07db9c9b2a19a6f3e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b072dae6365d0da75d5a1b358d55c617557a30ba57b6840642423483e19e8e4"
    sha256 cellar: :any_skip_relocation, catalina:       "67f938f125892ee83537884098065ac1d99e5278ab9a680763aff1408c2ce9fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "241d854b1c27795b7956316d42576aeb80f5e1b4b0b2642a803231dc7f7f6ee9"
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
