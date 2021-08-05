class SnapTelemetry < Formula
  desc "Snap is an opensource telemetry framework"
  homepage "https://snap-telemetry.io/"
  url "https://github.com/intelsdi-x/snap/archive/2.0.0.tar.gz"
  sha256 "35f6ddcffcff27677309abb6eb4065b9fe029a266c3f7ff77103bf822ff315ab"
  license "Apache-2.0"
  head "https://github.com/intelsdi-x/snap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "094be117be921cca221b7e0021e7e7d48d496e83599ed52fbd81c64b3b389d5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e8cca8dbc731cb1bf7b92a8f410f287678ab270450cd0f58ce6f10eb7e3e1d5"
    sha256 cellar: :any_skip_relocation, catalina:      "6f52483af1ce2785dc7e9bf0fdc202430c61b804ef3a67e2487d669bf27edcb1"
    sha256 cellar: :any_skip_relocation, mojave:        "1cd9b411854596b3afe7afa22ed9041d31e21a860739246a5eeb47e03a6844e8"
    sha256 cellar: :any_skip_relocation, high_sierra:   "066cf3014caa27b6c3327f983cbe632cb85476c0731ec3fda40e85205c1a5f71"
    sha256 cellar: :any_skip_relocation, sierra:        "1ff53b8b2f1827e2a607d81dd3db246eb1388dfd1aa7110dcf59a8e4ba606d17"
    sha256 cellar: :any_skip_relocation, el_capitan:    "50ce1be7d6e83f309d8fd62bf2b36cb03c29b726d575abfbeef895b3f628fb46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce6d7532d5ca326b0bd497988ff5aab340c49f6e9334898ecdf312df73b1dfa"
  end

  # https://github.com/intelsdi-x/snap/commit/e3a6c8e39994b3980df0c7b069d5ede810622952
  deprecate! date: "2018-12-20", because: :deprecated_upstream

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV["GO111MODULE"] = "auto"

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
