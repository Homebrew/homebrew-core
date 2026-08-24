class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://datanoisetv.github.io/tinyice/"
  url "https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "492d1bf7ccfa1f4b63f3a75a25878f8b008c07f17f620f7e378893b560f6aa93"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37cabb175b9fed77f78d7125c438d19e293730801212b609a799963c12e54e3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37cabb175b9fed77f78d7125c438d19e293730801212b609a799963c12e54e3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37cabb175b9fed77f78d7125c438d19e293730801212b609a799963c12e54e3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d6cde16e46b122f09117bfec56cc56f0206bd52cf69df6194833031ab57ffc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9202bfd8325aa2217a1b0bf590a968dc9fee8ac84c45b04f83cab99e09bc8f1f"
    sha256 cellar: :any,                 x86_64_linux:  "2cb54685efffca053953a2b4860a57ff617502e2b6456ee2425d5566ccf8b071"
  end

  depends_on "go" => :build

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
