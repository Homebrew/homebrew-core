class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v24.0.3.tar.gz"
  sha256 "c8a118f1b67cd29d04e5795cd3802682dea2445a5389723ca9c4fc7979df0e56"
  license "Apache-2.0"
  head "https://github.com/vitessio/vitess.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7110a8d0188868cde972192fbfa9e430206a29a0970e359c21116a5bf5be5d99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7110a8d0188868cde972192fbfa9e430206a29a0970e359c21116a5bf5be5d99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7110a8d0188868cde972192fbfa9e430206a29a0970e359c21116a5bf5be5d99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f71c00fda71cdeadc2f3d5c7238b06e968eb4d6ffb347a2fbef93a91a464ceb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e62f944d347415bf24c530dc94b38ca0581d6590e7aeb5309e9f359d2933399"
  end

  depends_on "go" => :build
  depends_on "etcd"

  def install
    ENV["CGO_ENABLED"] = "0"
    bin.mkpath
    ldflags = %W[
      -X vitess.io/vitess/go/vt/servenv.buildUser=#{tap.user}
      -X "vitess.io/vitess/go/vt/servenv.buildTime=#{time.strftime("%a %b %e %H:%M:%S %Z %Y")}"
    ]
    system "go", "build", *std_go_args(ldflags:), "-o", bin, "./go/cmd/..."
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtctl --version")

    ENV["ETCDCTL_API"] = "3"
    etcd_server = "localhost:#{free_port}"
    peer_port = free_port
    cell = "testcell"

    spawn formula_opt_bin("etcd")/"etcd",
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
    system formula_opt_bin("etcd")/"etcdctl", "--endpoints", "http://#{etcd_server}", "endpoint", "health"

    # Create necessary directory structure using etcd v3 API
    system formula_opt_bin("etcd")/"etcdctl", "--endpoints", "http://#{etcd_server}",
           "put", "/vitess/global", ""

    system formula_opt_bin("etcd")/"etcdctl", "--endpoints", "http://#{etcd_server}",
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
