class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
    tag:      "3.61",
    revision: "8ae00e47a6e3adf340cbf00269cebec2dad5ba5e"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49057409518be8dc8b828e13a86763fbeabe73c8a07716b92ba5f301e45e5822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f99cf41c59a5e88b23336560080406149e6913e05fa8ed66450bda519118838"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17ce9213903d3a7486c016009712fd46d3dc8fa5c08f9da1f24b99cd543b88b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "97ca9eaf52010275dd1a61055a89ed207240ab099b4ec4885b33ceba016d9a51"
    sha256 cellar: :any_skip_relocation, ventura:        "4b68e4b564baa2624473ce93d6b2600faca5691e0a85c651563cd7bb8a47fc5c"
    sha256 cellar: :any_skip_relocation, monterey:       "c32010fb1d690b7634e6ad45917c51e4f3cdfe4f1bf0654cbda6572cb950b9c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "700faab5f6ccb8c164e172f2c843ebf4467a6ad9e9612f8d684e716b574e48d9"
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
