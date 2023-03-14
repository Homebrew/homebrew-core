class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.136.37.tar.gz"
  sha256 "c1457ae31cf349e48b064324593a4303ae181071046074d180bf9947a82258d7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e3c7e1d64167d67a2b4e05b7ad692d7163959085528609fdcf5a0091943563f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6669eea0b838929f32f1a39d15bfa95982d27503340061f78628f12f0eeab6a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbc11831f6c28908c879d8289fc76e937206184a82d195eefeb52d0da491c816"
    sha256 cellar: :any_skip_relocation, ventura:        "c1df40df464c69177361d800ba959338c485225abb40072cf4f320637e769c31"
    sha256 cellar: :any_skip_relocation, monterey:       "77d2f4f72fca0abc063cdf31c03131ad7475956a4fd06d387992ce4b7ec30e5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "20d7248fcb31157d8f72564ed1b46a6bfb10f024a87a91cc4b97b273a372f5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0d7a7534b55078b371ba346b104e1abf2002975da68a2a44e6e3e3d3e15ac26"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "all", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
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
