class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v22.0.0.tar.gz"
  sha256 "578203a3235ee9a316856b9bfa46c7029563776e38b120a12694fac80d8c789e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16a6abc713f036b56ce408a60f7133fdbe607e15aafd5ea17e4a0a613c9dd3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98eba4660c3560f37b844e64696150bd94340c78348934aed4a72d8cbec4aebf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73ffb944b44b897c9dd208840f5d4f02dde196dcdd66b7db994ed8e41e097f28"
    sha256 cellar: :any_skip_relocation, sonoma:        "769c69de6a43a87539b779a114e3cf7d2f8e1fbab5e0f5da280df4f645d94fb9"
    sha256 cellar: :any_skip_relocation, ventura:       "0df7d6bfd7ce29c244988390eaa03bfd30eacc46fbd038d4192091fe115f6c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b44df86fd12e97c866c6f712e456c0ea4442053d3e572570b4b24feeac9b8a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6284282fca8d95b967a7b8ee7abdb11693168261121ae6c71bb395c34823d417"
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
