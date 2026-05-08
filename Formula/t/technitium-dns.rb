class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v15.1.0.tar.gz"
  sha256 "1d1f2d01519da0fed3b2b28ca982b22f3978d035ce2edeb1a2d8c197d656b78c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ae75108693e7085bb0a62f55ce698eccc17829d8a0df6161b4bf85a97081748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9915234ee77cab8f76c48719de06b5e9209157a5ad3e18eb0e3007e7db56d25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84925f247b9fcdf8672b2e1f337e29380ce34a044f14494b7babdf6c7b648a7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc41d8f1b82d38a872ee526b02e59942efb9a7112f95fdc421097e62aef763e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67042a13d5f7dec17aa6b325bd78be01d65d78fc9c8134c8fd901b875605a68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d796ad29117a50b58408f8920a3a596f4161e2c56e0ea48d61a4507e99d62aaf"
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
