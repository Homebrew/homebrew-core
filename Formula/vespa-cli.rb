class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.159.53.tar.gz"
  sha256 "3259af2f4ffafbe4349de9556154e00788d4880fa736fc49384a8eb0cf5aaebb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64e65d5d94d1a18aca514b515f797701773478ef18a13438b2240cd75cea5a97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ccdeb09e5009b1711de1810527c799ac168078b35336242a5f6fd256fd766e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9563e3a4b6241092ca9c287c913679aabadc7a262e593d4279388f9214e21c44"
    sha256 cellar: :any_skip_relocation, ventura:        "739c6a9145b86a291494be1166e73387babdce03a48f14b98ef27c33901293f0"
    sha256 cellar: :any_skip_relocation, monterey:       "5a73baa52a8262819379abe782ee55a65c59a03ad0cd0f6116160c3a1ddc91ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "b12d974656517734524c1c7bbefcbf9d0b6815b447f548c5d6ba9265957e5c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4be199ec6b46290ee3dec091d9aad508c17834de8636a04db8548931420616e1"
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
