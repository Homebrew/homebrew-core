class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.87",
      revision: "e4e85052082e31c94cd133270afc9e8365641c8c"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a625ca1ba63fbe03c7ef49a55b25247c7cc6c68aed68e00e579a0995ce06e69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0771c73268e21108a17d87321c95f9507c8fc0d23026e788d266d270034cb1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46d492c11b85255145656e7dbbb566bdaa941750e79bfdec3f481657ff5e1eee"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ef2670f09ed733f3aca7af05fc928d09ae520febda7aa7cb69e0f4566f57c4c"
    sha256 cellar: :any_skip_relocation, ventura:       "585625f581b7c7e478b28f76156f36d446677264d18cf6070e284b325b965015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6720978820100991f4b2e630287a2014dffe462c737120f5df4305086c6b389a"
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
