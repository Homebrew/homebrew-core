class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v24.0.1.tar.gz"
  sha256 "272ea5406c50265cc88d5ff1b36da1869bb914cb1bc482a70df1c51389ea65dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c43113dce825328b95b2039c605a3631108ecf150ace6453f39da23702fefbab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25db5916f12030b60818a7b5769d3a1251cf314dd46433e8c663c71471a5e620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bd5490b0377e5a979d5a2836389af806cf6b52275dc1c98eb3db1d19d27ec23"
    sha256 cellar: :any_skip_relocation, sonoma:        "767934518ea6e6255391ac02956d46eb8155b354985a01ecb92b9dca00f72ed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3e8e7b40d0e0d93803c21df11fc9fe9c112a9b0b17851437b226e6616f44974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d4696432f973f4338b981818d2ca69d7548f0c0631f7a385bf30a447a6a9db"
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
