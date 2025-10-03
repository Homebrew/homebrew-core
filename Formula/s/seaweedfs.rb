class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.97",
      revision: "76452ab593995ab52b75e681de5b221de1e3f006"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21e03b0434df7b8ad74ec01046aeee095dd6446b8b7b2b8c2d49741f7e6e98b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e26f3238aa6e10b6ae35d9d7ff0231067ea09cdfd2e5f7c16c9f260579580cd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72c50d1aed6ad5f59d4478be92b669c2a9856d5cb3821d43cda4f55479673c1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72144b35522e03afde6222858f949f04ac90d442849169f4405b333366dbdb13"
    sha256 cellar: :any_skip_relocation, sonoma:        "274df166b330a924de264d47265aae9341c3bec344c716dd98574755461cd821"
    sha256 cellar: :any_skip_relocation, ventura:       "502b5a966b4be1f84128d478981f06f0561def9d2eeb8b8ef3f17f1fdf5084b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1fa64fa862a40430cf8d82da238ed996b4982271f3028bb690206fee90ca1fa"
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
