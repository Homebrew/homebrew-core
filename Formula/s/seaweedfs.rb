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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9bf212196c280c57feeceabcf81349be0660584602476d22a0ae3b229838ec45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91176b374867dcf33849cba7209e35a392e90d187e46a2c6627a7a0e5f2c755d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42e2a3fd076879286dcd84688a07b357565387d4e81f70fb14a02d04927737d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53934defa0338efe2463cbeb665177b5c4ec1390b68f5a56805477bfca03f8c2"
    sha256 cellar: :any,                 x86_64_linux:      "960fa41f2bb7bf2c9d6c535262c30d5c6158ba4b42dbf0811e194a9583a2bf6c"
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
