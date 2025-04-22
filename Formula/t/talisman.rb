class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "273c200ce3950d3064c2077545b0d2d41d1c14708f61343b30ea8ee667b83474"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8efdf72894ee81f99878be02786e948060d44acdc9dfa03103e68d7011b718d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8efdf72894ee81f99878be02786e948060d44acdc9dfa03103e68d7011b718d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8efdf72894ee81f99878be02786e948060d44acdc9dfa03103e68d7011b718d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "749c043095ab979fefb76bf2390fd9f1df635f23a9bb370dd07f55b7b442aa16"
    sha256 cellar: :any_skip_relocation, ventura:       "749c043095ab979fefb76bf2390fd9f1df635f23a9bb370dd07f55b7b442aa16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4935128183e1ef6300923e9e7f903e2efd80088caaefd374e2bd730aaf37d56e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
