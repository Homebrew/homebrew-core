class SnapTelemetry < Formula
  desc "Snap is an opensource telemetry framework"
  homepage "http://snap-telemetry.io/"
  url "https://github.com/intelsdi-x/snap/archive/1.2.0.tar.gz"
  sha256 "a9dd4727e9044d2067c1e95b37f7c5db32175b198e6c488aedde292777f9eb5e"

  head "https://github.com/intelsdi-x/snap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2676fbe80fc6b0c6888258ae2c515780bd369f8b662dceca8d6d8a371b8d5480" => :sierra
    sha256 "bc2fbb3ca43e058ce66f14b51cdb0bc8df16858f1911f6f5941a372c1ed977ac" => :el_capitan
    sha256 "bdd97463314785303574f2fa5fc024b4b9171138e67d29f15135eafc59d12017" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    snapteld = buildpath/"src/github.com/intelsdi-x/snap"
    snapteld.install buildpath.children

    cd snapteld do
      system "glide", "install"
      system "go", "build", "-o", "snapteld", "-ldflags", "-w -X main.gitversion=#{version}"
      sbin.install "snapteld"
      prefix.install_metafiles
    end

    snaptel = buildpath/"src/github.com/intelsdi-x/snap/cmd/snaptel"
    cd snaptel do
      system "go", "build", "-o", "snaptel", "-ldflags", "-w -X main.gitversion=#{version}"
      bin.install "snaptel"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/snapteld --version")
    assert_match version.to_s, shell_output("#{bin}/snaptel --version")

    begin
      snapteld_pid = fork do
        exec "#{sbin}/snapteld -t 0 -l 1 -o #{testpath}"
      end
      sleep 5
      assert_match("No plugins", shell_output("#{bin}/snaptel plugin list"))
      assert_match("No task", shell_output("#{bin}/snaptel task list"))
      assert_predicate testpath/"snapteld.log", :exist?
    ensure
      Process.kill("TERM", snapteld_pid)
    end
  end
end
