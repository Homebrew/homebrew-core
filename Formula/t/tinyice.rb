class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://datanoisetv.github.io/tinyice/"
  url "https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "f95d5b9aa49ad2c266d84bb3e209e20533fb4b2643a2c63fc6d74f07f42716f6"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a75752a781a67cfa7c6f5a34f2acac8b72d821482328ee5f5eefb75107bfbd6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a75752a781a67cfa7c6f5a34f2acac8b72d821482328ee5f5eefb75107bfbd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a75752a781a67cfa7c6f5a34f2acac8b72d821482328ee5f5eefb75107bfbd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e2be705546e387c3b98bcf268119c768a3e0fbe4d548dc4af4b44ec09342171d"
    sha256 cellar: :any,                 x86_64_linux:      "e04a8ba471d241381d7e8e2a48da63a22d14291de6e77276a9507c09f77ee667"
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
