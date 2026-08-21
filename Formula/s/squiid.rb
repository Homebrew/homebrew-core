class Squiid < Formula
  desc "Do advanced algebraic and RPN calculations"
  homepage "https://imaginaryinfinity.net/projects/squiid/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.3.0/squiid-1.3.0.tar.gz"
  sha256 "bcf83dcc8bb1374866ee4fb8b31b96203476bb8cdde80cb0d24edfdbebd11469"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fafefb958aa0ca0e0f13a3dbc8b7f320ccba065c07b2648074edff7bb022cdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91d532cf3d6df4d588888343fa5ce18f7c2f3dc3b95c435aec001afc51404f58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2afc1d225a574be54952dc9d99b4287e825c3e7236baded5bb86d12640f8bdd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d439fec1f96a0b4ca61a92fc31d73a0588a735bef8fb035d24907dc05b17727"
    sha256 cellar: :any_skip_relocation, sonoma:        "99fbaf75468bd39f33fac158ba621e21cd057a4fcf8b0aa7da5a88858f69128c"
    sha256 cellar: :any_skip_relocation, ventura:       "3bccfe7343fa9c5b740f1c3bd29f5364313a8643ac4d2d5ec57dbec64fb09352"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9271c4fe7fce39db2b4500368e46dc1443d82583c456204d4c9c8838d03a307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a8e97c67a0436e66467376c4c913e0025fec990b1ba314b03ecdc0f4f67e06"
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
