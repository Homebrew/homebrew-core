class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.84",
      revision: "95d8f4415aedf3ec911f47d3e7f9459248c71c97"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16ba689656d5556bd765f5449447d082c9da7e1c00b016f67bd02dfc6b5ba09c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff35a1ed7930d46ba906f1deaa47b9d0cf3389d16da1e6763ce2c20df861de64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80159f613c8223ef26308ba8f85d812c4eaf8c70c8048718e00ebed49b94162a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c9b47c3964ce333cc86e672ba1bd4a8f710026df53494ec341c46d01e387c5e"
    sha256 cellar: :any_skip_relocation, ventura:       "1ba79de9b91bcb9d0b94c6b835ce72474c656beaff4df081e3c5d06638c6788a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565495d933ac83ff0d5806ffe0fea8aa83ffe50766cc140d65265a2e538b6958"
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
