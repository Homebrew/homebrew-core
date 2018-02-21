class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v2.4.2.tar.gz"
  sha256 "6bd838b5202f56e1801a8d182c74fd376bd0a212083f75519dad3614ac444c90"

  bottle do
    sha256 "65bbcbd2121170da66d97b2d0cffaf41ed1ea3e023ed1680864f0a1b1a6dd4ec" => :high_sierra
    sha256 "2d4c4637539a4ab9e7c0553bc0f9dadd521f601080cae33027ff3286081d0311" => :sierra
    sha256 "a76cf5bf24bdd889658c743339d92faefb9ed6bbe01a8d1d3bf70c3df9823f0f" => :el_capitan
  end

  depends_on "go" => :build

  conflicts_with "etsh", :because => "both install `tsh` binaries"

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    # Reported 21 Feb 2018 https://github.com/gravitational/teleport/issues/1708
    inreplace "Makefile", "-j 4", "-j 1"

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
