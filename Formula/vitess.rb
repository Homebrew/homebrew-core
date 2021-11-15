class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v12.0.0.tar.gz"
  sha256 "f20f84014236fc89b993d76facb08b7ade85121e1ef94db42503ce9e3aff6adf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c81c47e220b7387bee5d003b0f3049db8e5a6d9ba0ef3a48478957ad6f3069d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c6af5dd5faf4aa7bf6debc58a3cfb68081745f8f7ebcdcaaf2c004e5cb2bb64"
    sha256 cellar: :any_skip_relocation, monterey:       "8eaaed8085736146033d50f3bdef1443a4843289e4f1bf57787d9fe3313eb7a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fb047b2ff939b8cdc7907b9bc95968b94d6837d40432a31dcb266af20304967"
    sha256 cellar: :any_skip_relocation, catalina:       "79893cb774f092950a70b8f50fb4b7c9bb418c5c94494263733fcf7fa2841338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e056f986c71427c43be17ac6f75d3a455255cc1388d3d20f3e78c60c6ca69b0b"
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
