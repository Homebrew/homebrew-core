class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v10.0.1.tar.gz"
  sha256 "8d12aca42b912af114df56b70672977b0f0304808016f0515e360ab0b34efb13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5be3ef5ba9d7d9ed144f00ff3a956d75c81609bc8eee17442ab8c320ce2cb36a"
    sha256 cellar: :any_skip_relocation, catalina: "8de036858b583762a19b4dfe403ef522d41908531d6b06300d36c85415b089f4"
    sha256 cellar: :any_skip_relocation, mojave:   "2071ac655b1436703474f8da06828bc1975b22cc5fd5c31c89845733a1d641c5"
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
