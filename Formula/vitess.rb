class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v14.0.0.tar.gz"
  sha256 "1296a940da3a46508c09cb6ff2e4bb4f8f11c7522081714e8de4322f866d502d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f65519aae9487d58aa2a0d7d6bafa579a02af2212f41b254e5efa4ce31bc87ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d0515535cac3b56aba20f4ae694753d81309db5e6ef963829755a18e0be4ed4"
    sha256 cellar: :any_skip_relocation, monterey:       "e182720afcb72d5b82a50d82291469444a8f83efe090c5d9c4da9deae1a75add"
    sha256 cellar: :any_skip_relocation, big_sur:        "7906d95a1badc5a01f660c4c27173e36f98d791236923527c75d48e72357ac83"
    sha256 cellar: :any_skip_relocation, catalina:       "9115b7956fc01a1b8620305d733b443fd13e961d3e5abb2e1ba1cf04a4eeb320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71fa33eb10f4cc0225669ba4caa135aa33c7b103f4264d32172bd7d5738b9a2"
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
    ENV["ETCDCTL_API"] = "2"
    etcd_server = "localhost:#{free_port}"
    cell = "testcell"

    fork do
      exec Formula["etcd"].opt_bin/"etcd", "--enable-v2=true",
                                           "--data-dir=#{testpath}/etcd",
                                           "--listen-client-urls=http://#{etcd_server}",
                                           "--advertise-client-urls=http://#{etcd_server}"
    end
    sleep 3

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/"global"
    end
    sleep 1

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/cell
    end
    sleep 1

    fork do
      exec bin/"vtctl", "-topo_implementation", "etcd2",
                        "-topo_global_server_address", etcd_server,
                        "-topo_global_root", testpath/"global",
                        "VtctldCommand", "AddCellInfo",
                        "--root", testpath/cell,
                        "--server-address", etcd_server,
                        cell
    end
    sleep 1

    port = free_port
    fork do
      exec bin/"vtgate", "-topo_implementation", "etcd2",
                         "-topo_global_server_address", etcd_server,
                         "-topo_global_root", testpath/"global",
                         "-tablet_types_to_wait", "PRIMARY,REPLICA",
                         "-cell", cell,
                         "-cells_to_watch", cell,
                         "-port", port.to_s
    end
    sleep 3

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
