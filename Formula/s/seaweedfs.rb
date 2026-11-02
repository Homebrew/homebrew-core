class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.52",
      revision: "984eac6a790be89e2a11de175a7413e1e3e32dd3"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "012bd146a6632bb39a2f51e7d6ebadd1cd237d39efd8ae4f9ad53e60f383c0a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56085d7efcfae193c1faed01e55a3dd07c98d014926f469a3324e91be8abba6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00c2de7691070dc5afe5bba8655e0a8db6dd1ff28459ac2ebe48ec1928cee78a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "647572409a6cad27788216d57300b94b34bd8a6db6a257224840e713e34e4828"
    sha256 cellar: :any,                 x86_64_linux:      "f2f7c121b6dc14c1c105a0f48ccc8a8351f168d46f12f19bee58960ff4510c84"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
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
    # Start master and volume servers separately as `weed server` links them via `/tmp` sockets the sandbox denies
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    spawn bin/"weed", "master", "-ip=127.0.0.1", "-port=#{master_port}", "-port.grpc=#{master_grpc_port}",
          "-mdir=#{testpath}"
    spawn bin/"weed", "volume", "-ip=127.0.0.1", "-port=#{volume_port}", "-port.grpc=#{volume_grpc_port}",
          "-dir=#{testpath}", "-master=127.0.0.1:#{master_port}.#{master_grpc_port}"
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
