class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v15.0.1.tar.gz"
  sha256 "7ef5b2725e6565016db0171c70abeb5acd9609c681a1f8cce4c80c062b6ff39f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a10199b11b92e68b8fdf3a2d867162a969cec6db7ffb401e64f437746c73b55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4c08162e5f6a01d87e6cde7a2b73c3da7b52e9f8242f272d70400477f65bae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6101a7456c9973a91bec6e2aaa9b2ce4b59da79aa54a768733660c6df5a2f53"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f10fd48f9ce8b71f1de380b98150b5a35ad4d01ff9efbedb239fa4a44830e82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74355202591305ec2711270aa7bcaeb45a995e57be56c497f43f4ae4f15f9f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5215174988d9c1fa13eea80fc5bc237aec2a1ae24f1e5eeb944dd9997ce7f55"
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
