class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v7.580.54.tar.gz"
  sha256 "5820253d2582761f8e4dcf5df0e1a37f4a3152a33feeca9517676679f9daee3a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e75ab326a12368b7d037b697cb4ba323bde7113ae025f72659165b8938895f92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "881bfd1568686817387b6a27726a30ae267b2d03463e2f9e5a553d741a98dafd"
    sha256 cellar: :any_skip_relocation, monterey:       "44e9f6f0d95d634ee5fe383e09c1b8b32e7d2dce82f445a020c97f5132620b02"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc6348b17655c54c7867df3bd20588bba5773ca477ac1e6cf2942e75a3f9ff47"
    sha256 cellar: :any_skip_relocation, catalina:       "42e2cafa1e3c4f6ec8a3c628e44056a8cbeec73ebca557a869be5aca7970a6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82ec5b0f8aa408f790defe4cc8da58989c3ad6c0060b782133568b2f155cef3"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      (bash_completion/"vespa").write Utils.safe_popen_read(bin/"vespa", "completion", "bash")
      (fish_completion/"vespa.fish").write Utils.safe_popen_read(bin/"vespa", "completion", "fish")
      (zsh_completion/"_vespa").write Utils.safe_popen_read(bin/"vespa", "completion", "zsh")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "vespa version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
