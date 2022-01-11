class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v12.0.3.tar.gz"
  sha256 "f517a013fec7751a7da43ca2a11a4827d75ba1fbafd310bb10b9b3066549df60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7408c0c135fd24477d0372bea43bd800a6f3c556fb793bcb1144153467ca37a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdd83add8df585cb7b35773a885a9932b9125ee1639027a4b54c45286efd565f"
    sha256 cellar: :any_skip_relocation, monterey:       "8a9fe9b58b840eb1c9c956869338b249f5c6ed724b6a46b1eed6aec46c4c1951"
    sha256 cellar: :any_skip_relocation, big_sur:        "48c2e3bf47e6b8db640cec9f67d8849edfc835100aed51120d560f0d861ec95d"
    sha256 cellar: :any_skip_relocation, catalina:       "a1b76a95ff2e7660e1cc896ffbe0057df245a0ec95c2d05357a9f648820ede9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861bafece13fc35de445b82638f94bab9c00c4694ea5f7dbfe80504fe0c89639"
  end

  depends_on "go" => :build
  depends_on "etcd"

  def install
    system "make", "install-local", "PREFIX=#{prefix}", "VTROOT=#{buildpath}"
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
