class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.120.11.tar.gz"
  sha256 "a3c3c275ad19670fa54bb7a06babe3528994976a306f636af511437ae4b45b2b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22db69f69c933b2fedee04d522aa5f05395c9337834456baddac0bf0352a0a9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b935631206d609f69b2e68c48e26af58f9d1d59a9f503b56decfb37edecab0ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a4aac3d34eeeb124ab228a11c964bf3f2403e35c52dd3eb60ee9e6f48251600"
    sha256 cellar: :any_skip_relocation, ventura:        "bbbbbd940457c5c5d6e7cc4aa2cebcde5f7a59a8f755eb65f78d2532211efdeb"
    sha256 cellar: :any_skip_relocation, monterey:       "0bd331e864f51df1e65b061ccfd13c20fcf3615fd5db485825099c99256b00a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e3bfb9f15dd98c9ef5c9158e117a643beb9d7c813892fd43caf6f5f42c768ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "968106865d82e7916a960c13fd553ef94fee02973cd1cb941e2ed38e4fe80da0"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
