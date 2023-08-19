class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
    tag:      "3.55",
    revision: "7eafa3420b8e5ae83c8873cddd03ded90a0fc921"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "716e06b3c2541ec81fcc1f295289862c0ba9390a7d50f3556ba21c7f11758fcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "713577360e705959d1e6ee9d917725f0b2b82c81cdc53e6d8ba6df8b328f2167"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "447ddc107fe2bc17ba19e394deb3a96460387044340646cdb55239d18d7c2e5d"
    sha256 cellar: :any_skip_relocation, ventura:        "8c971bb841fa43e4dd421c9b15f379f01b12ab943efeed523b763b9d216f0c95"
    sha256 cellar: :any_skip_relocation, monterey:       "b3875b781a84a7e0fa4bef07eab21d1ec37b437049fc7c21223268f201828424"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fb52c67313d299520b114b8bf49fb7489376bf15b769b575d4fe2a3df118eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "776bfc5b8e84d94ea6ead89df309decb5d1affddb8adcb4ba99df49f5c4503cb"
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
