class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v23.0.2.tar.gz"
  sha256 "f32b112de130e53073b2abfc3b64a28836dea8f9f2ff42e3265298ec44d51a2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a8bef5f13343ac744abd83462d0d29bcfeeddef96458a65c24f282522df7d3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e84cfbe8c043cd7154ddf6eeade961e1655dfb1c4291643bbf0bd4239f8654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcf2e1bd26f4e1abe5b4af751bb2e5a93c75ea68831d7d226643f88e4e0ee42f"
    sha256 cellar: :any_skip_relocation, sonoma:        "66984c58ccb0d07c24dd4ffeaaa0d902eecf72b2d0ac9d6c39c1773b886d9118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a81b2109237ebf34c2e5514f974b4a2711e5a852f17826c50a8dfbc006e45d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aca7ed0c4b00c241e15ccfde86a134d7d775a1a94f7327d3ac2bab799d5af23"
  end

  depends_on "go" => :build
  depends_on "etcd"

  # Support Go 1.26 and later with Swiss maps always enabled
  # Upstream PR ref: https://github.com/vitessio/vitess/pull/19088
  patch do
    url "https://github.com/vitessio/vitess/commit/1e131ea41b87a047acff3b1977d9fece8e25bfff.patch?full_index=1"
    sha256 "6dd13ffbde947a2c0d426c5a6361e3f0f708c9fc1bd1df7b000ad06fa8644a9c"
  end

  def install
    # -buildvcs=false needed for build to succeed on Go 1.18.
    # It can be removed when this is no longer the case.
    system "make", "install-local", "PREFIX=#{prefix}", "VTROOT=#{buildpath}", "VT_EXTRA_BUILD_FLAGS=-buildvcs=false"
    pkgshare.install "examples"
  end

  test do
    ENV["ETCDCTL_API"] = "3"
    etcd_server = "localhost:#{free_port}"
    peer_port = free_port
    cell = "testcell"

    spawn Formula["etcd"].opt_bin/"etcd",
          "--name=vitess_test",
          "--data-dir=#{testpath}/etcd",
          "--listen-client-urls=http://#{etcd_server}",
          "--advertise-client-urls=http://#{etcd_server}",
          "--listen-peer-urls=http://localhost:#{peer_port}",
          "--initial-advertise-peer-urls=http://localhost:#{peer_port}",
          "--initial-cluster=vitess_test=http://localhost:#{peer_port}",
          "--auto-compaction-retention=1"

    sleep 3

    # Test etcd is responding before continuing
    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}", "endpoint", "health"

    # Create necessary directory structure using etcd v3 API
    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/global", ""

    system Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/#{cell}", ""

    # Run vtctl with etcd2 implementation but using etcd v3 API
    spawn bin/"vtctl", "--topo_implementation", "etcd2",
                       "--topo_global_server_address", etcd_server,
                       "--topo_global_root", testpath/"global",
                       "VtctldCommand", "AddCellInfo",
                       "--root", testpath/cell,
                       "--server-address", etcd_server,
                       cell
    sleep 1

    port = free_port
    spawn bin/"vtgate", "--topo_implementation", "etcd2",
                        "--topo_global_server_address", etcd_server,
                        "--topo_global_root", testpath/"global",
                        "--tablet_types_to_wait", "PRIMARY,REPLICA",
                        "--cell", cell,
                        "--cells_to_watch", cell,
                        "--port", port.to_s
    sleep 8

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
