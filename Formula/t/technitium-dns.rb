class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v13.5.0.tar.gz"
  sha256 "7a5f47af4c938c5983e415547b777f853ede5ada8837012c8b5e8e36df1a380e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda28a9edfd838d85510d9663c0a24c3f1c404c072bf30cb8f3cfb21990837e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cc7e7cad9743fbf3261a1417f03a97d1bbfc37ad544420e4803105c7ec60eff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8ae57540aa984adcf9d21a2e4a30f7be73998036fce3e5ae0d84bc742693051"
    sha256 cellar: :any_skip_relocation, ventura:       "079e61452c9d175605d9b960b49e24a5237f7da639d0765328c374fda5528da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae32179d807f94701937e9abe29110da7b81e7e977168c8d4e27628ea0d5465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda1cc0e7223d0c3b8b7e3f9a13af438e6fb4109e731b690544fd9c162182154"
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
