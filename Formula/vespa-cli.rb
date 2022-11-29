class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.90.59.tar.gz"
  sha256 "b371360f4eda7df32b81694d7c55dd5f5810197d06548d47b75ff48ac3313ae5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fe78972213ab15d42becebd8530b560d8f951379ebe3c72500953481377488b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f0663b80ddb3efd46505b1e0e9527eb23b6ff8db1bdda96b1e561001a0d11c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "680b7da9a54aa3d78a17ebe1f576723ff5ab8f2b75b68723e4a0752a948395c8"
    sha256 cellar: :any_skip_relocation, ventura:        "f1c4bec0a46aaf4a44b4a8f40e5a50b40f9d4904d0213a6c96e308d0c3fc3d19"
    sha256 cellar: :any_skip_relocation, monterey:       "7fcfd0035ea3e7103a7b15dc742e20ec7a3b5f0de28f2a9a1f79fdc3c9dd5da5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c979467f9f4fa6bb51eaf8ab4a0282e37551f51d4f3f5d55f2e368720b4fee2"
    sha256 cellar: :any_skip_relocation, catalina:       "13cb7beb8d9104d9939e1ae6309ff80424ade84d89e600420eda1105d3b53568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b35c422af8a6e193ebdfc9cbb4429e63ea6f036dd6b1def563a805208feb58"
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
