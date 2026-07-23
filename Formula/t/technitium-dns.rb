class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v15.4.0.tar.gz"
  sha256 "07930c2f1d6ac40d18bd73ac897cc49c8bc1effdfe0819e56910e06a53dd41b1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1f9589bb845e20fe1656aa2f5497cfc6c38c7e8afac99e43e35e97a2e1e094d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ac6b266bc1b4049133a31fe2dc740c6c4fb78790c4c0c9c86177251b56fc342"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e6be35d3f857eefd16c05243ae0477cc563c1c7c4032807734f2bddc5259217"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd1e87cc0bcf3e8d38de1973058325cb731ced1fad42abe97551a6c536f50191"
    sha256 cellar: :any,                 arm64_linux:   "2d4c052c18c61fd0e4084d0c737a47639ae0f443d72a3ffe71a919eb8f38ab8c"
    sha256 cellar: :any,                 x86_64_linux:  "9d865328dc5a00d9194c26dabbdb5c0fe610bb40e5c738688a5c09ee267c81f0"
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
      export DYLD_FALLBACK_LIBRARY_PATH=#{formula_opt_lib("libmsquic")}
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
    environment_variables DNS_SERVER_LOG_FOLDER_PATH: var/"log"
  end

  test do
    dotnet = Formula["dotnet"]
    tmpdir = Pathname.new(Dir.mktmpdir)
    # Start the DNS server
    require "pty"
    dns_cmd = "#{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{tmpdir}"
    PTY.spawn({ "DNS_SERVER_LOG_FOLDER_PATH" => tmpdir }, dns_cmd) do |r, _w, pid|
      # Give the server time to start
      sleep 2
      # Use `dig` to resolve "localhost"
      assert_match "Server was started successfully", r.gets
      output = shell_output("dig @127.0.0.1 localhost +tcp 2>&1")
      assert_match "ANSWER SECTION", output
      assert_match "localhost.", output
    ensure
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end
