class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v2.5.6.tar.gz"
  sha256 "7a7168df106b1d4ea3b81b5078eaf6ea8f6063b11c7171202d2e2b9bfbdcfe2c"

  bottle do
    sha256 "47e53170ebbc529512aed21426ce9433f4586096c5790b36225fe78096133d1c" => :high_sierra
    sha256 "4f0d2b9fd28fd58dfb41a1635e95db874889fb76bc3b5cc150d4e40c21748f96" => :sierra
    sha256 "bc30df10cf7b1b85ac4af9ce2c7b84b08566fc2aaf8b9482fbf6ada6eae4b0e3" => :el_capitan
  end

  depends_on "go" => :build

  conflicts_with "etsh", :because => "both install `tsh` binaries"

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    # Reported 21 Feb 2018 https://github.com/gravitational/teleport/issues/1708
    inreplace "Makefile", "-j 3", "-j 1"

    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "full" }
      bin.install Dir["build/*"]
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    begin
      pid = spawn("#{bin}/teleport start -c #{testpath}/config.yml")
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
