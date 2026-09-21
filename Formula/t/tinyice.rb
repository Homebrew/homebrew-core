class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://datanoisetv.github.io/tinyice/"
  url "https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "d3816726c366f0fbbe68a9a507d1a1053fbdecb8f4d0a1294335e63381692854"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5cda2e7b7113cbc7c52868c3ef40102e8752a9101de088eaf64aaa2635255152"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5cda2e7b7113cbc7c52868c3ef40102e8752a9101de088eaf64aaa2635255152"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5cda2e7b7113cbc7c52868c3ef40102e8752a9101de088eaf64aaa2635255152"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1de3602f29b6bc0977ba9d8cae1fc4850ffb1ce5570d8a3dae7f1ce5153e9509"
    sha256 cellar: :any,                 x86_64_linux:      "099bb764d26f09e04274431616a1688db103711e036a3a6120edb48d31dc0e70"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"tinyice"]
    keep_alive true
    working_dir var/"tinyice"
    log_path var/"log/tinyice.log"
    error_log_path var/"log/tinyice.log"
  end

  test do
    port = free_port

    # Write minimal config
    (testpath/"tinyice.json").write <<~JSON
      {
        "bind_host": "127.0.0.1",
        "port": "#{port}",
        "admin_user": "admin",
        "admin_password": "test"
      }
    JSON

    pid = spawn bin/"tinyice", chdir: testpath
    sleep 3

    begin
      output = shell_output("curl -s --fail http://127.0.0.1:#{port}/")
      assert_match("TinyIce", output)
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
