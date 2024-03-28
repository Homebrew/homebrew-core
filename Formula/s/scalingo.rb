class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.31.0.tar.gz"
  sha256 "9f6c8b1304a338062e7254e85855d84a94f09c353e9d6b2ebb38dc147ee44a11"
  license "BSD-4-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d904b1938ab315ceeb52989d03f52302727959eaf38cf079a516ba64ab63076"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e444e7642de574079344f2c3df5cf2d82ecc32b1f387bd3fe0749b9ffcafbdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cea9c2b4870cb71c2628c0bcf44602789ce64ebfb439e8d26fa7a3de24eab99"
    sha256 cellar: :any_skip_relocation, sonoma:         "248ed9ff3b31511772c74d13a6132c0f8e5b22df86cc9bcbf1a3b442f2cfaee9"
    sha256 cellar: :any_skip_relocation, ventura:        "eecd5bab58c9b16baf8e1c044d6c02874dd53fda8150853ac43b9ddec594407b"
    sha256 cellar: :any_skip_relocation, monterey:       "1bcf522cee5755598c9b3aa41a654b85a1479b352f910591004522df2cf1d624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62cf45b08a3c9f1198ef7d386edef0bbada116824fd8c4aa97bc8bac4f1cfef1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
