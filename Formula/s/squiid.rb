class Squiid < Formula
  desc "Do advanced algebraic and RPN calculations"
  homepage "https://imaginaryinfinity.net/projects/squiid/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.2.1/squiid-1.2.1.tar.gz"
  sha256 "36dd7cc418ad3366d47865ffa2fab63189f3115bdc3b693a10ac37b5101a03c7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d75e5b1cf12807b0d6eddbe4a80f03adc03e0bd1ba58a1a746f3cdffd88e7576"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ab55be031ea0dd115b28d5696468b458b989680995c51a78fb57311bd51f0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5b00187760880272bff7e30ab10a8a813baff3a0cd9a50b482be0d7bcc1ec3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d24608b3d73e5ddb2cbdfa6af660a2d6e21b3ee2766af37404855081712225d3"
    sha256 cellar: :any_skip_relocation, ventura:       "c453840820bc658a883cbc8f77abe60c6cdb014c62e8f1855f60797b3b52698b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2603c2c5e666331d6b7c870069b14531423486b91059478f6841c8841cf65b75"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # squiid is a TUI app
    assert_match version.to_s, shell_output("#{bin}/squiid --version")
  end
end
