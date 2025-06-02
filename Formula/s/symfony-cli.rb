class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.11.0.tar.gz"
  sha256 "29996a4f7f2032fe1e3b1d8df734843f84ee7e2ac9db10e1e690ffc37df88713"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d47dc98f5d38c5284110ae1efa4ed7c1288d07f01606e858b500cf347f82601b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d912e1b871a1c1dda5ad88ff4d99d7dfaf4e8f49a14e90b570b4673edd1253b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72ef3cbff4d00dddbef4cf615224d325cdd1e4e7e704ff348233bcfbfd1b0c9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d26574687c410530d91d9d9fae06e8a0330bb2ed4b37ba3e1f3473d8c547374"
    sha256 cellar: :any_skip_relocation, ventura:       "a87a33ae5beaaf2113b0b4f94ec66328d0d562fe88c6f9ca40c7ad249e0dd87c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c3b7f8262d00c957e3d5d1493bcdb244843f17fcffc55bcaa1e6e528a8cc222"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.channel=stable", output: bin/"symfony")
  end

  test do
    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
    output = shell_output("#{bin}/symfony -V")
    assert_match version.to_s, output
    assert_match "stable", output
  end
end
