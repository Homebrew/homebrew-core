class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://datanoisetv.github.io/tinyice/"
  url "https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "f95d5b9aa49ad2c266d84bb3e209e20533fb4b2643a2c63fc6d74f07f42716f6"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b48120b24084c5680beb6571316492ae353998a2348ef3384f5460874acb9b00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b48120b24084c5680beb6571316492ae353998a2348ef3384f5460874acb9b00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b48120b24084c5680beb6571316492ae353998a2348ef3384f5460874acb9b00"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2799f5b693a7c134bed5059a5538a38a8e782a7aec3638c34271a10f3d6af207"
    sha256 cellar: :any,                 x86_64_linux:      "29b481f0401a7eeba9e2286e354577e363118f5aa1f00d5cbcc9af190be12069"
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
