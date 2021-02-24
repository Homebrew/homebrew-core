class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v9.0.0.tar.gz"
  sha256 "14254f423f2472fb48034299cbfc4acc6b767f7497036cf43eb3e7f2a70f7beb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "aa51ca8319e5c017cd77fdaa3118773164cb06e4d2d463a026804d756d9a48ee"
    sha256 cellar: :any_skip_relocation, catalina: "9391247e8271f55f85ef108e5b8e55c9f529686bd104d4fa0c2b0075790efd6f"
    sha256 cellar: :any_skip_relocation, mojave:   "51709fef029ab1134ed279f5d597c8e9c794dc5d9fc117845119f9c9b08a78a1"
  end

  depends_on "go" => :build
  depends_on "etcd"

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
