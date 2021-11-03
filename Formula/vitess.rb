class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v12.0.0.tar.gz"
  sha256 "f20f84014236fc89b993d76facb08b7ade85121e1ef94db42503ce9e3aff6adf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d7de1a40fc1fa9e6e77e3ae7a795e0155cd82e6e4b00c579813142eb70066fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4aa971754b4a25ba92ee044864d45ed528a7247625c4ee02f0593d5be05bf0f2"
    sha256 cellar: :any_skip_relocation, monterey:       "c4d4555d17a7746fef01ef12af90b591be43d83631ce882e5bf5923ab7e2223d"
    sha256 cellar: :any_skip_relocation, big_sur:        "223ec20c9812977bfa7b27f4c8bc96543151539d0e290c79e4a77cc5194cb886"
    sha256 cellar: :any_skip_relocation, catalina:       "fd69b5532c0a3621f749415cc6123b26184393177207d22dbb926f57cda306b2"
    sha256 cellar: :any_skip_relocation, mojave:         "379e273a0fa00df8967402dbaf3a2ce7d4ee4f34059bed832f22caf1d12a446a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2c25804ecf48402255647450d13fcefbae378bd00fe84fbab45a13bd36d2708"
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
