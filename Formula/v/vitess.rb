class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v19.0.4.tar.gz"
  sha256 "5293a9ee440a0e3d383b94fd81511adfb90657c42f1d3b73d1c54f85e3435fe9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e93af6a98cfb7566e55c080711bcfdfe96d40adeeaa590ced322f4a378712945"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abb20c12d52612c8e8b449008590f35878429144a1ad5c98939be101c488c223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c46578aad94c2caaeb80db3027d89fa04adf1a7ea4002bec6a1f2bcffcf87fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f44a7481bb4efb41447276fc6f94059eebd71561a70b5ebbe276ee1c033223a"
    sha256 cellar: :any_skip_relocation, ventura:        "f375723eb1168dc39ad9950de6d2094db117cefa4e2c40c59be29589cc2612e2"
    sha256 cellar: :any_skip_relocation, monterey:       "7db1c449b82115fb290b92ad6c5b507e81767da21cf7487639d333bd951dfca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbd709c9dddd1e8514f2ed0787e109424cce2dbcf5ea9b7d981c6e6a7c9bec07"
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
