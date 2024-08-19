class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.72",
      revision: "e50d85c0f3697caf0ff9aca6662d59b4327a8424"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "606373c2f3cb5205a859a85c23e6f319068fe7e09af5ba927390d962cebcc74a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96e47d5a130ce66bb60b7501187b5ea11257dff22b55ee3ea4f973a59c87e811"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80495a7556dd1fd8e9513b0982eab5d6f0bf563183b6c39198da1104770369fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cf7111012b613298a7ba2230c8cea2ccc8354b80f8ebb470ead97d0063eb3a8"
    sha256 cellar: :any_skip_relocation, ventura:        "9e9c6a352850a281bbd6490280b638576f304eed9216841853842909e3d72f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "6be94996096b18ff1b6153838008aa6305bdc7614c6b009a1fca4c452b341473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c2260abf2af2173599cbcd352f78515a183429c6edca6cee6086011557cf6b5"
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
