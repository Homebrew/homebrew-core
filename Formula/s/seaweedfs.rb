class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.40",
      revision: "875cd1f67ea25e8965a4f5ba1e6aaf501ba6b6fa"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9798d9187392bddcbb5c06b7bf9bde5efc0681b8a44480e2fa78b889080475e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4766a24b88cd66bc2b04800bf12f59805a663c747d9694f3b8e5a3391601c304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fe7761f8b4d3717c82a7c10002825be16a974f5d3b2d67b9ec825dd30900a63"
    sha256 cellar: :any_skip_relocation, sonoma:        "192b1b1e598f580588a8a55fc277219cd2bf3148ae92cf2acf0bc18ec939f3d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06c8629580bde6e40985554a72bae8540086b55b2b997db52b5857a0fbaa7f3a"
    sha256 cellar: :any,                 x86_64_linux:  "3339114415a3a5d6db38306eed26aa2a27f2a45f93bc4a2cdba25e592ca455a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  post_install_steps do
    mkdir_p "seaweedfs"
  end

  service do
    run [opt_bin/"weed", "server", "-dir=#{var}/seaweedfs", "-s3"]
    keep_alive true
    error_log_path var/"log/seaweedfs.log"
    log_path var/"log/seaweedfs.log"
    working_dir var
  end

  test do
    # Start SeaweedFS master server/volume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    spawn bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
          "-master.port=#{master_port}", "-volume.port=#{volume_port}",
          "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    sleep 30

    # Upload a test file. Volumes are created lazily, so grow one first.
    system "curl", "-s", "http://localhost:#{master_port}/vol/grow?count=1&replication=000"
    fid = JSON.parse(shell_output("curl -s http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
