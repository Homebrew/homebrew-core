class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.238.22.tar.gz"
  sha256 "12b3e732de91a1791c456c7d53ff0f9870bb388dfb6da43b3d69645d98fd3110"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6b8e4494b11fcfb5322b50cf69e811130d1b69fcaeaa5b421e071de00742c35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95415159bd7f8bef383231dde85da2b2e294f9a2af0938ff0411a12f104350a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db9a54312b8e6ef63147e1a10033bb3b4ffae90598bdd76b38fc185dff817c03"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a3f3d13070502e8be9708ce77d2e09bdddf2054acaaabea92f30d5a3e4cc772"
    sha256 cellar: :any_skip_relocation, ventura:        "eeba090a78ea00eaec38bd43359b3112a93ce0169549d85a88ac78b58db083ec"
    sha256 cellar: :any_skip_relocation, monterey:       "4ed808de1ebcb1c8b13d2d185a38d5d84fce134b72902fa4291afd37e19de6af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c285f8460d023f2d4c04d056302eba1ff1b470ac3ed95acf4b80c70a7ec1028"
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
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
