class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "fe26f4725d65708c64f191cd7c423008163dfbd8f1aaf765615980d7aaac4141"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a8f04d18dec9f3e50772fc7f38f6cc0861dc6b69c4423c11bbcc42601899fd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88da328d82d16da8bd35fb1a812e333ee9f66fdd7d122dd7c4d9b74c9bf9252f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9450c564253b710552be56c6c5558c1a397d3867db454e8b14db7e0d6199b026"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d939f4e097ccfd8d63ddcfecf80ab6fabae7fe1ec58c3967a30be6631185d14"
    sha256 cellar: :any_skip_relocation, ventura:        "51badb18e2d828820558177500e665c17fe8478bd376e29253e59110088abd00"
    sha256 cellar: :any_skip_relocation, monterey:       "2743127840f76c2adc8e135897d2542ffbc9a14820259ca73302456df8cea009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02b5b7509b4178d6c4a1a425dbf7eeb7240148a593fcabb98a4a9310070eeb7c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}/skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}/skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/skeema --version")
  end
end
