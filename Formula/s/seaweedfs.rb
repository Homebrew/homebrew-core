class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.76",
      revision: "82ed61c6552e5095c682131012c91594ad2643e6"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14e8204c105029f9b1e75bdbd4c55e92209ba9e4a86f755e9c26a60f3eba44d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2698c472da3ceacae922bc8e3d6831b3411fa956bcbf1c72f2405ee2447db500"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e445625756bf33d1740ef2ba07db3b5ade67bb524a1089280f9120f0c1678b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0702537b99cc1aa7e07cd4f1b68bcf73faf02d234418d220166f7d6611560a3"
    sha256 cellar: :any_skip_relocation, ventura:       "f682da4874deb588a7d2e93b09e1d738b4ee29b4e64fa1504cf90b74aef26c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e9df74f8afb30ecdf77cde768c1330776595e7f5328815d606e2ce5dec5e64b"
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
