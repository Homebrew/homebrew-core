class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "f232ed196559fd5cd72e1f32e63e940598a777204312e9934df18e6c88294af1"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "834d537424efc816ebd0138b348ad4af400e0695be77452cccdc9b5c92d32906"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80590e11ce500d3e840dceca2a68e404ab58b5cfbf9b8c09b1ece7205cef9b1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d88dc1548c9b5524f9f85806d11d3d8bcdfcaba95a123ccb6f692227923f5c75"
    sha256 cellar: :any_skip_relocation, sonoma:         "349a1f66dfa7997a381ebed0fca5a0b2ae0cb841300c72f6d79426a5d95e7870"
    sha256 cellar: :any_skip_relocation, ventura:        "07c7b19209a01ff7f622093ef3bd15f2c42fee2ddaddc3334f900487f45dbbe2"
    sha256 cellar: :any_skip_relocation, monterey:       "55cf218050a08322dc370353b70eb37b7104e1a0da53a751a5c2180faa9f3a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5041e5fd0111ad81f88423c390bc6debd16548a7b3b2bb90e30c5fc304fd11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
