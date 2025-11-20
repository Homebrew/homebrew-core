class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v23.0.0.tar.gz"
  sha256 "4048df4344eeead97dbf6126e09b9ccb2c5d83258bda19028f641b9a9f4e0b07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0527e0ec0169239cfce80fd83afc8dc7a3842dcf46b9bf6f04190a6a8b1a497"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef496ff7737cf572799801c4059d256b4ed1ac1ac01547afc638ff082e1c29d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6d79d861b8078513bd8cc9726491dde8370e2ddf33a5f07510e4c21d987ad0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5699f4f1344bc9a1d36dcefea6408bf2ffeecc6ba45d9d440764b0a7213b2064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b06c3c77949112420f47ddc3224c75497e657d79f92b5c9efec1fdffdb5d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61fc570d8c084fc88cfa3c4170aff428a5503edd6ac9f666a1735e88f675acbe"
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
