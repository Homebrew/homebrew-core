class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v10.0.2.tar.gz"
  sha256 "f9446e717f05e0b42dcb652e0758e1e6949d287464942418c140269b875963da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "eceb3111673e616d616f38f479a1e5508a9d1a93c04dfaf269623f006d3f19f4"
    sha256 cellar: :any_skip_relocation, catalina: "49aebd85d9ffdfa4bab9c3cda7bc8c1680098989718247304125d746a9079814"
    sha256 cellar: :any_skip_relocation, mojave:   "44ce90c92d9f2ab747c932ed1ff41500cc5ee41a07d357916a9f9fe21a165fc8"
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
