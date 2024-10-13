class Stolon < Formula
  desc "Cloud native PostgreSQL manager for high availability"
  homepage "https://github.com/sorintlab/stolon"
  url "https://github.com/sorintlab/stolon.git",
      tag:      "v0.17.0",
      revision: "dc942da234caf016a69df599d0bb455c0716f5b6"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5a9cff2775f8b7655d68bd8899ae8090a23c1d38add3f842fd850ea5fdd3b258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5051a16e7d948aac0ba138307c7a1a3a5f53e1ca0683bef81823bdb752037002"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2ff141e91b71942f67871741dabcd110310a06c72d68ce361391e2a1ce233ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17af62bc7751903d4f85e447907825f3bf4df255263487c47b44e299a9b196be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "767212e3c8d9dc59a030aa96083a48f42be86fa4c43b1df2158c6d3d9fa50f54"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c7dcb4122593003e6ced2dc77fada593f90c897a0ff6f23b607d530d554cdcd"
    sha256 cellar: :any_skip_relocation, ventura:        "ca9b4d2758cdb30d4d68573285228d3ee30f007b0a10f2b1981fca2b5f3ed300"
    sha256 cellar: :any_skip_relocation, monterey:       "6e82da7f0cd74193592f16415ba7386c7483bf9006814177df8086cc96e7b57a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2955ce82d16c3601d928d8f7125bda27dde894fd9e8b8c8e2025a178c38cb640"
    sha256 cellar: :any_skip_relocation, catalina:       "6f8469a79e442788d8a8c774c7097ee45d1deeebb17968c79e4efbd37965e69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ca55abf39725e1760d6610e38ea05f089fd382724da55c170f2cf914ee1050"
  end

  deprecate! date: "2024-02-04", because: "depends on soon to be deprecated consul"

  depends_on "go" => :build
  depends_on "consul" => :test
  depends_on "libpq"

  def install
    ldflags = "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}"

    %w[
      stolonctl ./cmd/stolonctl
      stolon-keeper ./cmd/keeper
      stolon-sentinel ./cmd/sentinel
      stolon-proxy ./cmd/proxy
    ].each_slice(2) do |bin_name, src_path|
      system "go", "build", *std_go_args(ldflags:, output: bin/bin_name), src_path
    end
  end

  def port_open?(ip_address, port, seconds = 1)
    Timeout.timeout(seconds) do
      TCPSocket.new(ip_address, port).close
    end
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
    false
  end

  test do
    require "socket"
    require "timeout"

    consul_default_port = 8500
    localhost_ip = "127.0.0.1".freeze

    if port_open?(localhost_ip, consul_default_port)
      puts "Consul already running"
    else
      fork do
        exec "consul agent -dev -bind 127.0.0.1"
        puts "Consul started"
      end
      sleep 5
    end
    assert_match "stolonctl version #{version}",
      shell_output("#{bin}/stolonctl version 2>&1")
    assert_match "nil cluster data: <nil>",
      shell_output("#{bin}/stolonctl status --cluster-name test --store-backend consul 2>&1", 1)
    assert_match "stolon-keeper version #{version}",
      shell_output("#{bin}/stolon-keeper --version 2>&1")
    assert_match "stolon-sentinel version #{version}",
      shell_output("#{bin}/stolon-sentinel --version 2>&1")
    assert_match "stolon-proxy version #{version}",
      shell_output("#{bin}/stolon-proxy --version 2>&1")

    system "consul", "leave"
  end
end
