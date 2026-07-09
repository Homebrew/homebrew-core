class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://seaweedfs.com"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.38",
      revision: "65dff4a492df39b33e8e0378a9d70ed94cb3469f"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82b93aec2e3ef92418667ec174edd15f978467f99581e83ee97b3cfb1c0419f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2b980bd7610d001100f558f458455bdd9cc0e8fdf443085c32e9f1b2286c0da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e03ec35282034e90d4156d5f898ce007219a9cd74520edb2940d62d706053e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6123850fd2819ce0a8f814809b80de268ca3cdb43cb92bb53535ad20ab9d82e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "922696a89923273407b924ae49f88bf2438dd7b12ce2e7444ac062564055d8a9"
    sha256 cellar: :any,                 x86_64_linux:  "c79b7e179b84b7ed92c1c3ae779e00b474f3011cd057d0fac3536484341d832b"
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
