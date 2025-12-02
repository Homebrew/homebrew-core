class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v14.2.0.tar.gz"
  sha256 "757410eca1b32b626171383fb2b05dd001cb536e2ef0ecdc2f9c373ebcb8afea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb0c547fcc0ce17425a84a0c08f1748d921071a7ec27e229e59495ea867063ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9b839fc6ed49062d508c10f78a0f65396032e859c3f60a3dbd06bbb4c11cca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bee7eaf03df88c242376b8874e3cde915b4ce744060ea98a7bd616382c74f07b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00723b4c7ab01b4c01a7796e079cba3841781008d7ab51512c6c632e1f73917f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0058e612905569a02dbae4f0d4db37a942b24b9b89ac5ac6f30eae6ee9e7970"
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
