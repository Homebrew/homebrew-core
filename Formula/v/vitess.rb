class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v19.0.1.tar.gz"
  sha256 "9322ef57c5a8313edb5d34f75f0c3e30def16bffdb1314b580d36b0a4a964b9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3589502e33c77c1e4e11c51a77eb9321b23bbca590cf4ad701515e990ad3f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffb362b934debabd283c429729d99fa45a2f6c437217013896e775bee35314ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f4cce935b52f574e72f59bda7ff7534099b4d0c51aff3fb7131b9c2761a6e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "dda0710f1297c292fcf144ddadd9b59db1bc6fe4a03ee5e0bdb148bd08a73116"
    sha256 cellar: :any_skip_relocation, ventura:        "d78f856a50c4e062e5196f86f811d8e85d729cd77f9eede03d53e594b168b81e"
    sha256 cellar: :any_skip_relocation, monterey:       "2c9da325e7d45c6293986fd4e1b9db03eff67fc61d80255ccc03d04022010c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "502e4d7503fef3e91256a04b2eccd4b3f94968166dcc3861bc3624497547b037"
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
