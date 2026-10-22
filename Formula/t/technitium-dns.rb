class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v15.6.2.tar.gz"
  sha256 "7fe162a7c1db828ca3ce0d754e9739118e5d666ddac526d2302509b47c3d513b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1bd7da4ce294a6024bb095e6cbbbaa03c3f6a855b247bda743f44ef71dbb876c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6211a64ce374fa65aaf8896ed85c904167bd578f2af61f23dc37ef0e12e38e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "126e5b530051886c59fb5f977d7414d958aded471a5f005c63e41bb1f2bd5ead"
    sha256 cellar: :any,                 arm64_linux:       "b1759001fe356e46056825ebd041ddfc8ba8fe44951a85252f4718c898e03943"
    sha256 cellar: :any,                 x86_64_linux:      "3edf0c1262bf7d89558dc6aa0a1e4b65fab7b4d684c3855916ef4be089465ce3"
  end

  depends_on "dotnet"
  depends_on "libmsquic"
  depends_on "technitium-library"

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  allow_network_access! :test

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    system "dotnet", "restore", "DnsServerApp/DnsServerApp.csproj", "--use-current-runtime",
           "-p:TargetFrameworks=net#{dotnet.version.major_minor}"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["XDG_RUNTIME_DIR"] = buildpath

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

    (bin/"technitium-dns").write <<~BASH
      #!/bin/bash
      export DYLD_FALLBACK_LIBRARY_PATH=#{formula_opt_lib("libmsquic")}
      export DOTNET_ROOT=#{dotnet.opt_libexec}
      exec #{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{etc}/technitium-dns "$@"
    BASH
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
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?
    ENV["XDG_RUNTIME_DIR"] = testpath

    # Start the DNS server
    require "pty"
    dns_cmd = "#{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{testpath}"
    PTY.spawn({ "DNS_SERVER_LOG_FOLDER_PATH" => testpath }, dns_cmd) do |r, _w, pid|
      # Give the server time to start
      sleep 2
      # Use `dig` to resolve "localhost"
      assert_match "was started successfully", r.gets
      output = shell_output("dig @127.0.0.1 localhost +tcp 2>&1")
      assert_match "ANSWER SECTION", output
      assert_match "localhost.", output
    ensure
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end
