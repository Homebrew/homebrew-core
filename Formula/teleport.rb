class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v2.5.4.tar.gz"
  sha256 "cb89bb3e4083238d1b0982efce93227f36aef7542f34de6022795e0ce58de65b"

  bottle do
    sha256 "c05b8bdddf8ccfb37998f42bc76d1ae235dd2b5f6c498b1ec01560d103a28b3f" => :high_sierra
    sha256 "cef2cd4f4983972e9cb1f40676f1e85811a528f84053ff246d859efccf2164cb" => :sierra
    sha256 "a4d5efbbe34b155a21810ce6cb68a5c821e46aebb45bd8d68b5cc19c6d8b51c4" => :el_capitan
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
