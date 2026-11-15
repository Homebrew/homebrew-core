class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v24.0.5.tar.gz"
  sha256 "1979489971e3422437ead3906e9c25af553f5c211d5e53b2a34ae89299b9612d"
  license "Apache-2.0"
  head "https://github.com/vitessio/vitess.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2268434c2e51838c54bd81784cb9892710bf172f87b931e943e2038663973c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2268434c2e51838c54bd81784cb9892710bf172f87b931e943e2038663973c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2268434c2e51838c54bd81784cb9892710bf172f87b931e943e2038663973c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1bc0acbc770a4553387c0e957ecb01f68eddc151ef6f379b9a1e72fc65fe522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5f4b4aa4d82fd7a5054c966fe8292fa7c35c28ffb0dde089216457337bab57ce"
  end

  depends_on "go" => :build
  depends_on "etcd"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
