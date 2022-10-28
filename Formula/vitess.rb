class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v15.0.0.tar.gz"
  sha256 "0951281afc4b583248ca1ce323e882e919bcfd8d12122d6a610722aa67d6fb88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4352ef053f7440fd238beca302a5403eaf3283eaec2bee96c9d9f1dcbfd5420d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76e201d0f261a4ad46ce1f91087bc862be18c0afae618c7c3f8628fef3bfc9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "b90312ec97fcd0bd83792e3b2d284e75371e1e2fe1dba7f337358a67e493441e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff8131bdc076e4e670d87280d216fc255d7341bf85751c69ec63e6665850e9d0"
    sha256 cellar: :any_skip_relocation, catalina:       "5e18ccd4ec60b9e6dbb657f7b41a91853b835e60b2a86a76a8805e3abe9386cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b08d79ad6debfbf9289a408e6a3df44f36542d12cbe76b337fcfc057498d088"
  end

  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build
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
    sleep 3

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
