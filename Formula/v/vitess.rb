class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v22.0.1.tar.gz"
  sha256 "0e6a985b8c5298265f5acc171af3436c9286ea2474d133e76fcf280179a18c38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db0a99f71fbd8574507c5ceb58d614c13ce4b9cf39f5e0413993fd6494f0cd93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb64693b02895cc485400b2d025f64d40ede2d14fda76e32af1ffb935bd1e220"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ee3e21d62551620028558f157eba7520c9620588148cd417f98c9b6dd39ab80"
    sha256 cellar: :any_skip_relocation, sonoma:        "e63c59146c04bbeb674cb0f3a535146b6d14d9d685d546e99c51e307e599b214"
    sha256 cellar: :any_skip_relocation, ventura:       "508a2b5288196222786ac6772113f1b2df7df5c51589e594ccc4c19106ef8a06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7b34cd6fa22c026e94a667a68e3598c251fcfb7fb8e7caf21bab546e842bb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "475acb3982bb4167e4019f3126c7ec1541a173b43ecea92af4ee6efaa63961a0"
  end

  depends_on "go" => :build
  depends_on "etcd"

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

    fork do
      exec Formula["etcd"].opt_bin/"etcd",
           "--name=vitess_test",
           "--data-dir=#{testpath}/etcd",
           "--listen-client-urls=http://#{etcd_server}",
           "--advertise-client-urls=http://#{etcd_server}",
           "--listen-peer-urls=http://localhost:#{peer_port}",
           "--initial-advertise-peer-urls=http://localhost:#{peer_port}",
           "--initial-cluster=vitess_test=http://localhost:#{peer_port}",
           "--auto-compaction-retention=1"
    end

    sleep 3

    # Test etcd is responding before continuing
    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}", "endpoint", "health"

    # Create necessary directory structure using etcd v3 API
    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/global", ""

    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/#{cell}", ""

    # Run vtctl with etcd2 implementation but using etcd v3 API
    fork do
      exec bin/"vtctl", "--topo_implementation", "etcd2",
                        "--topo_global_server_address", etcd_server,
                        "--topo_global_root", testpath/"global",
                        "VtctldCommand", "AddCellInfo",
                        "--root", testpath/cell,
                        "--server-address", etcd_server,
                        cell
    end
    sleep 1

    port = free_port
    fork do
      exec bin/"vtgate", "--topo_implementation", "etcd2",
                         "--topo_global_server_address", etcd_server,
                         "--topo_global_root", testpath/"global",
                         "--tablet_types_to_wait", "PRIMARY,REPLICA",
                         "--cell", cell,
                         "--cells_to_watch", cell,
                         "--port", port.to_s
    end
    sleep 8

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
