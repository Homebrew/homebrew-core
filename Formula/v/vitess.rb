class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v21.0.1.tar.gz"
  sha256 "541cbb81fb845ef3c018e3f657f88d5987709b54c5b3af6718c38f5f92a8523f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2600887b52d6b5e104b110c527e8060bfe6e93385f10c4a2957a50908eca3f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec4ad943da8addad02d445980dac7f864d0da4f08971c2acf337bbc246c60e95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cebc4241cd0e4dbd80fae513d3d01dd81b7672f5cbdfe26cecb2965ac1da1c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e1c8b60baf533b7836c4c395ca37703c28ca63649387208df4dd57637f0737f"
    sha256 cellar: :any_skip_relocation, ventura:       "7063ef96870df68aa2a79dbe7b1f035ffa9f1eb287f74c90b7f6619bfb0f0e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d3a91b93f45b59feb01835e12752f96b0cc013d012438ca49aa121622380639"
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
