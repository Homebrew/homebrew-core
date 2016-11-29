class SnapTelemetry < Formula
  desc "Snap is an opensource telemetry framework"
  homepage "http://snap-telemetry.io/"
  url "https://github.com/intelsdi-x/snap/archive/1.0.0.tar.gz"
  sha256 "0868462d85bb08f8ad02ab89a95c769881ace1ad941b738a8fb394caf70b5a0c"

  head "https://github.com/intelsdi-x/snap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f511ccc9546bfbb75c3b61c7af3e86299137efab8e36599746df3ef8e72bbf3b" => :sierra
    sha256 "41ed14ded1571f4a9578cb5c254fbbf19c70a312d85d13ce86b5bb96f38cb059" => :el_capitan
    sha256 "40db8343a5afbd10d4dcca80d33496d52ad5ced91c2eec636812a5041fdf1725" => :yosemite
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
