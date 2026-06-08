class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.31",
      revision: "2a46d457ac3afd04d3572722a0a0244904d98938"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d78b419ca6e0094add4a037a958fdcda4458486c4ea184f2ec915277177642f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd12e092fbface5f4c3ca6fe8916f8f0b067610f6250ef5d494e6cd185f4a8bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b6736f22ea9c06b89ca0f46f355c5509359c5d1a929d6179f175a33b95c4f45"
    sha256 cellar: :any_skip_relocation, sonoma:        "34bb69773ab001669af0fa717654d07d8e7ee0dbc53ce785fce2d0eb2c6cdeec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a03295923e2a73277b52a48d518d1c37335e52fecd4e63f110abb17aa650755f"
    sha256 cellar: :any,                 x86_64_linux:  "a81b14555aa154e33d82b073840260c676ac7d3ef39a1ca11363ec699929ebe3"
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

    # Upload a test file
    fid = JSON.parse(shell_output("curl http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
