class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/refs/tags/v24.0.2.tar.gz"
  sha256 "5172351863c6a0bf034024cbd7d5d443f41606787e37a567c8e8f680c22af4d2"
  license "Apache-2.0"
  head "https://github.com/vitessio/vitess.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "005cd48faf1afe695775bf1091474aeaa9aaeded518cf84b9307db071bb2b04c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "005cd48faf1afe695775bf1091474aeaa9aaeded518cf84b9307db071bb2b04c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "005cd48faf1afe695775bf1091474aeaa9aaeded518cf84b9307db071bb2b04c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9af636b5cf712ef602873c99d237d263a6981dceff93ced239c65543215b668b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d88b87432805cc573463d21a459241c8d8ca41e454ee62a0b655f3c6f5e8eab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59318f7695252264bdafa36c9399f0f16bcdf44f8ba07d8c7107bc0fff9cdd21"
  end

  depends_on "go" => :build
  depends_on "etcd"

  def install
    ENV["CGO_ENABLED"] = "0"
    bin.mkpath
    ldflags = %W[
      -s -w
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
