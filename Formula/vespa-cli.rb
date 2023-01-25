class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.115.24.tar.gz"
  sha256 "36a39c1e9edb4f3044914f7760d57e85724b11c57ca2e619a0a2328121d37bed"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f371273cd20bef8e30f0875f82746ee63a2cd16ece98dd1920bfae5528630e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abad6b9b867932ad16712242e4c822b318e20b9d740c79f95ff5b723a0608a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "243e73d43eb574a177e3f44361d5215a4e26a157d4cf1add0a9a38f80f4c0127"
    sha256 cellar: :any_skip_relocation, ventura:        "1aec588c88f364bfca2d16d93cb5a440a27e7de716d960d0ba13791ceb7426c7"
    sha256 cellar: :any_skip_relocation, monterey:       "ff1b039f9f393c75da81250a0e57c43678db32e5e00d6f5bfc505d66e8c00bfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "869d78b86296dae77cfe9351a6bf6b8cec253e7e2affa5c2e71384964c869d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4d8952f1d56bf870e1631578e90030747189033a3823e3c8c7af32bffa1d67"
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
