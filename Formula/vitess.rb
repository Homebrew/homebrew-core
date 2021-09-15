class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v10.0.2.tar.gz"
  sha256 "f9446e717f05e0b42dcb652e0758e1e6949d287464942418c140269b875963da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "223ec20c9812977bfa7b27f4c8bc96543151539d0e290c79e4a77cc5194cb886"
    sha256 cellar: :any_skip_relocation, catalina:     "fd69b5532c0a3621f749415cc6123b26184393177207d22dbb926f57cda306b2"
    sha256 cellar: :any_skip_relocation, mojave:       "379e273a0fa00df8967402dbaf3a2ce7d4ee4f34059bed832f22caf1d12a446a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c2c25804ecf48402255647450d13fcefbae378bd00fe84fbab45a13bd36d2708"
  end

  depends_on "go" => :build
  depends_on "etcd"

  # Fixes build failure on Darwin, see: https://github.com/vitessio/vitess/pull/7787
  # Remove in v11.0.0
  patch do
    url "https://github.com/vitessio/vitess/commit/7efa6aa4cd3b68ccd45d46e5f1d13a4a7f9bde7d.patch?full_index=1"
    sha256 "625290343b23688c5ac885246ed43808b865ae16005565d88791f4f733c24ce0"
  end

  def install
    system "make", "install-local", "PREFIX=#{prefix}", "VTROOT=#{buildpath}"
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
