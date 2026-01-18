class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v23.0.0.tar.gz"
  sha256 "4048df4344eeead97dbf6126e09b9ccb2c5d83258bda19028f641b9a9f4e0b07"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e5062c627f55690c1d508ae83d4701108b622e8b98f246827c32d52cfaa890c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c0e5aaa0998b48dbdefbbcf78b9c2bbf6cf757b66499635e3ed9424c5f7b76d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a1e98fcb3238e8a6ccf7732856194c9d8b3d6c30cf2023e924ceb0160bd59ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "88bb197ebcebef61867972adbb702f6941d4d8b6e53473f6ec9eb09d248d32fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54145d2a4da2451a4b059a59504b5b09eaa810e4cbe611466e5744a06a46a498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31f4388df79ec234090e71ecf2601620263156d0dc2e816d6f92736d9d912753"
  end

  depends_on "go" => :build
  depends_on "etcd"

  # Support Go 1.26 and later with Swiss maps always enabled
  # Upstream PR ref: https://github.com/vitessio/vitess/pull/19088
  patch do
    url "https://github.com/vitessio/vitess/commit/1e131ea41b87a047acff3b1977d9fece8e25bfff.patch?full_index=1"
    sha256 "6dd13ffbde947a2c0d426c5a6361e3f0f708c9fc1bd1df7b000ad06fa8644a9c"
  end

  def install
    # -buildvcs=false needed for build to succeed on Go 1.18.
    # It can be removed when this is no longer the case.
    system "make", "install-local", "PREFIX=#{prefix}", "VTROOT=#{buildpath}", "VT_EXTRA_BUILD_FLAGS=-buildvcs=false"
    pkgshare.install "examples"
  end

  test do
    ENV["ETCDCTL_API"] = "3"
    etcd_server = "localhost:#{free_port}"
    peer_port = free_port
    cell = "testcell"

    spawn Formula["etcd"].opt_bin/"etcd",
          "--name=vitess_test",
          "--data-dir=#{testpath}/etcd",
          "--listen-client-urls=http://#{etcd_server}",
          "--advertise-client-urls=http://#{etcd_server}",
          "--listen-peer-urls=http://localhost:#{peer_port}",
          "--initial-advertise-peer-urls=http://localhost:#{peer_port}",
          "--initial-cluster=vitess_test=http://localhost:#{peer_port}",
          "--auto-compaction-retention=1"

    sleep 3

    # Test etcd is responding before continuing
    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}", "endpoint", "health"

    # Create necessary directory structure using etcd v3 API
    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/global", ""

    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/#{cell}", ""

    # Run vtctl with etcd2 implementation but using etcd v3 API
    spawn bin/"vtctl", "--topo_implementation", "etcd2",
                       "--topo_global_server_address", etcd_server,
                       "--topo_global_root", testpath/"global",
                       "VtctldCommand", "AddCellInfo",
                       "--root", testpath/cell,
                       "--server-address", etcd_server,
                       cell
    sleep 1

    port = free_port
    spawn bin/"vtgate", "--topo_implementation", "etcd2",
                        "--topo_global_server_address", etcd_server,
                        "--topo_global_root", testpath/"global",
                        "--tablet_types_to_wait", "PRIMARY,REPLICA",
                        "--cell", cell,
                        "--cells_to_watch", cell,
                        "--port", port.to_s
    sleep 8

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
