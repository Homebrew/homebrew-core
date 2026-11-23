class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.55",
      revision: "a98c9e27185cf1003eca095761a39973c60734db"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "1fdccaaf91f5ee71ef2b9ecb21ee920c7bb076a1d283f5d78b5f02a2e73e919f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb1764ef2db27b7a9dc74b2e84d8c0f22e27706b999f455c671d055dd72ea1b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fadeed156a08c68bcef7521f2bbecd274557949c9fee8ccba7d2a6dbeda6e06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "defbf71b0dd45a4bd2fca2b9cfc37ee670ed22255287e9c2619b66f12fc307c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4e5d5912c41df96674386900f5ca9199b297b75a875fa6d6d9ae9eaf4d44826d"
    sha256 cellar: :any,                 x86_64_linux:      "1452327a9e7c36e206246996d513cdc617e60f792fc3479e9d39df6c7bf421ed"
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
