class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.21",
      revision: "3ff92f797da66fc829dae254aced133de12a107a"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8392230c9a48ed3a19408530fc350dee1a03a1bb09990bdc9d2a960282b0643c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0198f8bf4bcff34b4bd8346694b7c4502993ce21fdc516103698d20b34dde813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1e6765d4dc9be769f34e56b3eee11c517b9f2218edeeb03cde6669f2794879"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f8fa92879eab8c164ecbb8d5742628631fa5abbd630cd827b02620eb87f22d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3660dcd6f226b0682d7118c2ebdb8c961dd0e83586ce2a7336b525617f7c7003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9dd03e820c0e3cf617d4cc461134b5982f35af9c56ab87938bcd3bc55bedbf2"
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
