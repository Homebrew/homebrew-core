class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v15.2.0.tar.gz"
  sha256 "9247b3c70a8f58d336741819b4550b29937815dc535d1cc0f36ffd7cedb8860c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfd22e86094c1f55fa0edbd719bae8cefb7faa29e447ff1f1e5836af4a6dabb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c3178955056ccf75f745a9b66c3f4a9ef9f42dad613d6abbcd29a1407b35017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64f8d5ede9fa6cd5cfd6a049ffa02f96bb5e508b365fe2ba7f7227eb9e68ff0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "703600b68f7becd81a473f9f5a076ba109ac2011c13d2a5ab62b9907adec1689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40c15ba74c3a852d580e233d67c741b93fba5fc704ece85d64022e95dbf4b9e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6ba13b569ff7e40f3c0b59281b4ce69178a2b1b2c27da4f4b83f433181e732"
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
