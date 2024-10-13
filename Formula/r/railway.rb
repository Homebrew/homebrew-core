class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.15.3.tar.gz"
  sha256 "60ccb129a192cb4da23d42c1252b1bdc4fd58d27419735c1b7f4fdb3016274c1"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eec231c84c5e60633f96e503d2a123dc5492665ed532fb10ba04687ed16db17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be81537c91e8680018b1ea927c25aaa55f7264062ba1b85b4cf371810acb5454"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1db299255df7d03a2394438992c65752647c831e603f22f2f82a3d4498f4130d"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd1d2452f8654c174208039e877cadd74945e56bee9c6beb5017f51856473a9"
    sha256 cellar: :any_skip_relocation, ventura:       "035b9f33dccf7c79942e0b72a1c854d3e39109b295e5e647cf320c5a0ff1c0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78a13078d4b23c09446350433abc55fbcb5e6286d20027e23bffa72943741836"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
