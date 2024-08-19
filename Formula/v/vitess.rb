class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v20.0.1.tar.gz"
  sha256 "186028b1cf9e2087330b9cbe7d57c772c5b040156cb23b2056871a5bcd249232"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b04ac8f89214d1b3ecaa764c7c152d880afa526b1084f850b5944b891ebe925"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e73c2a9a4a740cd8a11f60189fa8f45cd456c315a407212fe2cb2523f2ffa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0ec0494abc32ec5549aab3a626bc16009453c0770a159a12889c2c96d48ead5"
    sha256 cellar: :any_skip_relocation, sonoma:         "be5172d5a98636907ac7096987040d156db61a1340cbb87ec9b2296de66caee6"
    sha256 cellar: :any_skip_relocation, ventura:        "42a8ff53845586831e60363445c18d3cd562cd0b41fd22f6da54469e9594a41f"
    sha256 cellar: :any_skip_relocation, monterey:       "586f6a5f2c406008e5f125cffe59ff5fc3c987bd16fa35c51572e371153ec4a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff51d7d5e7d198c9deb005f8f6b867298a02796768eb52b785b621716af4598e"
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
    sleep 8

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
