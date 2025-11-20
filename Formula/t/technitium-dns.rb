class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v14.1.0.tar.gz"
  sha256 "a744971968143fee9fd87a60a5271c558c91b3ed10b411c3fafca4f30db3bc4e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aa2734b6fff8d63743ddc22a47b68a0269422a856324f504225856984c32973"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6443140423024e505f5ceace3f54f8e619fbb49f7f0a0f3220d3ed1a9b36b6be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dea5a9cf472d3a0982bc637fa561f6886bcf335865946e04b1ddc2db66430e6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36bf700b14e6f9344326e0753a45dad92c4446a388906414ea6d78ecd0e7d232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41fb61372209668920e1099a07444b95278dddf5611b1a4873a179b0214e1ebc"
  end

  depends_on "dotnet"
  depends_on "libmsquic"
  depends_on "technitium-library"

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    inreplace Dir.glob("**/*.csproj"),
              "..\\..\\TechnitiumLibrary\\bin",
              Formula["technitium-library"].libexec.to_s.tr("/", "\\"),
              audit_result: false
    system "dotnet", "publish", "DnsServerApp/DnsServerApp.csproj", *args

    (bin/"technitium-dns").write <<~SHELL
      #!/bin/bash
      export DYLD_FALLBACK_LIBRARY_PATH=#{Formula["libmsquic"].opt_lib}
      export DOTNET_ROOT=#{dotnet.opt_libexec}
      exec #{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{etc}/technitium-dns "$@"
    SHELL
  end

  service do
    run [opt_bin/"technitium-dns", "--stop-if-bind-fails"]
    keep_alive true
    error_log_path var/"log/technitium-dns.log"
    log_path var/"log/technitium-dns.log"
    working_dir var
  end

  test do
    dotnet = Formula["dotnet"]
    tmpdir = Pathname.new(Dir.mktmpdir)
    # Start the DNS server
    require "pty"
    PTY.spawn("#{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{tmpdir}") do |r, _w, pid|
      # Give the server time to start
      sleep 2
      # Use `dig` to resolve "localhost"
      assert_match "Server was started successfully", r.gets
      output = shell_output("dig @127.0.0.1 localhost 2>&1")
      assert_match "ANSWER SECTION", output
      assert_match "localhost.", output
    ensure
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end
