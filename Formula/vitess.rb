class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v12.0.2.tar.gz"
  sha256 "4d37b60cef3e2c926d916d3f0930baa1ec0988b60ecf88304198b678fedc2b46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17d304248163bf1f0233bf726226a0c910e1610b7e1932ba9211e46cabd88544"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3ae8da73e28231cc3a1d2c5ed8375653143a962047b5746e3d7a994c56699b9"
    sha256 cellar: :any_skip_relocation, monterey:       "6f21c1c18991a372f6e9260868d6c8e9e1f383e3b424788cbdaa143d7845ae06"
    sha256 cellar: :any_skip_relocation, big_sur:        "088c2a1ab7646d47d1dbdb29f5bd8006970ac982b12c7769d5612f7eaec81f79"
    sha256 cellar: :any_skip_relocation, catalina:       "9b8732c1823ec49ad8863604d8654bb0f83de78d423ae378f96f74c9aeb040b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bbfe78ff22503550e761b30e52ca37823d42430a5a4c8f8a9872d5343371040"
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
