class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.524.25.tar.gz"
  sha256 "92ac68c13f0f7f7aa545d07526192cf9f1bb4730d4e917f01131a4343fc04851"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4d1c28f8ec8349eea822ba06c17bb56a867ac783a3fcebcac37df30084b170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e663208434b36f0a2965b8ef23a95733486254bcf967b0f173a5a3ffdfbd396d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0173706a3f3dc72963b9e175d3a46b8635095a1892fc7501b0f298b0f5276b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "064a6f8981ba47539c288b19dcde856090a61d82d5137746d451d27157c5479c"
    sha256 cellar: :any_skip_relocation, ventura:       "03bbd11a116110e6705b1b45b893ffd7c2db9a3490b71abccb09804603dbff0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0651549ebb2253340594c5db655def89b29b17366577f77a7324300d32993a75"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
