class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v8.0.0.tar.gz"
  sha256 "c47320b9bcb874b1a6dfca78ec677be7c4bb4c7b2a6470df80bd1bc0ad125e92"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "etcd"

  def install
    system "make", "install", "PREFIX=#{prefix}", "VTROOT=#{buildpath}"
    bin.install "bin/mysqlctl"
    bin.install "bin/vtctl"
    pkgshare.install "examples"
  end

  test do
    etcd_server = "localhost:#{free_port}"
    fork do
      exec Formula["etcd"].opt_bin/"etcd", "--enable-v2=true",
                                           "--data-dir=#{testpath}/etcd",
                                           "--listen-client-urls=http://#{etcd_server}",
                                           "--advertise-client-urls=http://#{etcd_server}"
    end
    sleep 3

    port = free_port
    fork do
      exec bin/"vtgate", "-topo_implementation", "etcd2",
                         "-topo_global_server_address", etcd_server,
                         "-topo_global_root", testpath/"global",
                         "-port", port.to_s
    end
    sleep 3

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
