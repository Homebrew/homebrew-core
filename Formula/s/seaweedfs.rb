class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "3.86",
      revision: "df6f23068101f6fe817f93a128c688069ea279e5"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7498908fbd16a52bbadd88d40f5b67370400316b2a4f7740750d17e2b443250e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3bca0c46d378e30977b8ae400d1371ecf71e0f92c915cc6ace4a20e31bb41a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e90e48f4bb74fc9329be2fe7834128a4ba9d45e290c009f352df05b5a79e406"
    sha256 cellar: :any_skip_relocation, sonoma:        "600fd165d32c840351685d1a5155d8909a74023409df5f353f8eb809f0fb163a"
    sha256 cellar: :any_skip_relocation, ventura:       "ef940ef77aba9172a09b8e91aa8f702039785a6f1fa443c4fb69c093d33104b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38b769799ca5dc2e4228e9ae7c3b925de000da5ed34e6ae286d1e3e77159d76"
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
