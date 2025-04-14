class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v13.5.0.tar.gz"
  sha256 "7a5f47af4c938c5983e415547b777f853ede5ada8837012c8b5e8e36df1a380e"
  license "GPL-3.0-or-later"

  depends_on "dotnet@8"
  depends_on "libmsquic"

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  resource "TechnitiumLibrary" do
    url "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v13.5.0.tar.gz"
    sha256 "8e0f3200ad6ee6a1ab346a7224a1bc538f6b3dc1b660cd8bb725d0dc09fa2bf9"
  end

  def install
    # See https://github.com/TechnitiumSoftware/DnsServer/blob/master/build.md#build-instructions
    dotnet = Formula["dotnet@8"]
    mkdir_p "DnsServer"
    mv Dir.glob("*").reject { |f| f == "DnsServer" }, "DnsServer"
    resource("TechnitiumLibrary").stage do
      system "dotnet", "build",
            "TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj",
            "-c", "Release"
      system "dotnet", "build",
            "TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj",
            "-c", "Release"
      (buildpath/"TechnitiumLibrary").install Dir.glob("*")
    end
    system dotnet.opt_bin/"dotnet", "publish", "DnsServer/DnsServerApp/DnsServerApp.csproj", "-c", "Release"
    libexec.install Dir["DnsServer/DnsServerApp/bin/Release/publish/*"]
    (bin/"technitium-dns").write <<~EOS
      #!/bin/bash
      export DYLD_FALLBACK_LIBRARY_PATH="#{Formula["libmsquic"].opt_lib}"
      export DOTNET_ROOT="#{dotnet.opt_libexec}"
      exec "#{dotnet.opt_libexec}/dotnet" "#{libexec}/DnsServerApp.dll" "#{etc}/technitium-dns"
    EOS
  end

  service do
    run opt_bin/"technitium-dns"
    keep_alive true
    error_log_path var/"log/technitium-dns.log"
    log_path var/"log/technitium-dns.log"
    working_dir var
  end

  test do
    # Start the DNS server
    dotnet = Formula["dotnet@8"]
    pid = fork do
      Dir.mktmpdir do |tmpdir|
        exec "#{dotnet.opt_bin}/dotnet", libexec/"DnsServerApp.dll", tmpdir
      end
    end
    sleep 2 # Give the server time to start

    begin
      # Use `dig` to resolve "localhost"
      output = shell_output("dig @127.0.0.1 localhost 2>&1")
      assert_match "ANSWER SECTION", output
      assert_match "localhost.", output
    ensure
      # Kill the DNS server process
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end
