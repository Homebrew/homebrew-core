class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.91",
      revision: "c26299b05a67135636664fbbe57d9328a67288ad"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b5edc8698db303f2bd69af7b82b05437c2d24558bcd117a40ff5053e803fce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd9b92e6cc9d7dabf39709b400517ba8fba22e5b82be4c777970e1d4c3df7ea2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67248404de0acf748394a4b8642a5c23320bf47f8a59bba919070d38ce6520bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0688f102fefdcd49d331eabf09544aa329ed84db8f1bb2a658d4fedf8a951556"
    sha256 cellar: :any_skip_relocation, ventura:       "36c14bcd8fac941a119858edf56c6ffbc5256c914dd8ffc64fe1c6f367fd409c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be6abbf3fa230ebad9f9e27782e647be093d1d5d1caa886e308f07d246db2e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  def post_install
    (var/"seaweedfs").mkpath
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
