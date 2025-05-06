class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v13.6.0.tar.gz"
  sha256 "37ade6327dc63700b4a63db6347d3174112d8ffcb817645073f7e5e114e76400"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a501489591cd182a2acd46fa546b3cd716eed5fa2009c5943a76340e2198c666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "047ed2ef79d6f7b05619f0573e3f1a1bc60d45220ae23e40b0b5e851b291250a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68cf6f51e7498135466e5c74d0744fb848c01bcf7ce58179f6aecbd650f08fc5"
    sha256 cellar: :any_skip_relocation, ventura:       "6d349a289209bd35d1c01174290fcd8d83a22255edd72acd988c9b8fb29e686c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e21db5a1ac666bfc822ed4df1495afdc0fa3f843a17140e5909a346b9453e3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40c481b7ad55f8e17df945cef5b74b02fb887d3a9c75cb999761b79c23c0721"
  end

  # TODO: update dotnet version
  # Issue ref: https://github.com/TechnitiumSoftware/DnsServer/issues/1303
  depends_on "dotnet@8"
  depends_on "libmsquic"
  depends_on "technitium-library"

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet@8"]
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
      exec #{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{etc}/technitium-dns
    SHELL
  end

  service do
    run opt_bin/"technitium-dns"
    keep_alive true
    error_log_path var/"log/technitium-dns.log"
    log_path var/"log/technitium-dns.log"
    working_dir var
  end

  test do
    dotnet = Formula["dotnet@8"]
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
