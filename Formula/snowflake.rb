class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.2.0.tar.gz"
  sha256 "2310fc18fb5197007d9c49577604af5fad1b5e1826a8136aa7930dddace7860c"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"snowflake"), "./client"

    man1.install "doc/snowflake-client.1"
  end

  test do
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER environment variable", shell_output("#{bin}/snowflake", 1)
  end
end
