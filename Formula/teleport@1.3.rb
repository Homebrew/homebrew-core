class TeleportAT13 < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v1.3.2.tar.gz"
  sha256 "fbe6f1b02107f01865053d086224f78d5944556fc7d870b5454582391505b728"

  bottle do
    sha256 "31de9d5fe3e9e69f7086012c10dfb8018430ffeb4d8669751a06bd94918ddd0f" => :high_sierra
    sha256 "c892603ff642579bbc816a407a0ede5d06224d3cf65364eabe3ff7976790c20d" => :sierra
    sha256 "664a76eaeb9b5b716bedcf54abb380667eeeb49cef3063bc404515337b0f0c4e" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "all" }
      bin.install Dir["build/tctl", "build/teleport", "build/tsh"]
      prefix.install "web"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/usr/bin/hostname", "/bin/hostname")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    begin
      pid = spawn({ "DEBUG" => "1" }, "#{bin}/teleport start -c #{testpath}/config.yml")
      sleep 5
      system "/usr/bin/curl", "--insecure", "https://localhost:3080"
      system "/usr/bin/nc", "-z", "localhost", "3022"
      system "/usr/bin/nc", "-z", "localhost", "3023"
      system "/usr/bin/nc", "-z", "localhost", "3025"
    ensure
      Process.kill(9, pid)
    end
  end
end
