class Xtitle < Formula
  desc "Set window title and icon for your X terminal"
  homepage "https://kinzler.com/me/xtitle/"
  url "https://kinzler.com/me/xtitle/xtitle-1.0.4.tgz"
  sha256 "cadddef1389ba1c5e1dc7dd861545a5fe11cb397a3f692cd63881671340fcc15"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?xtitle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "62511b7ce2a8440cd64bdf6fb05a1015920d610f254f95d01fb020c1c58c819e"
  end

  def install
    bin.install "xtitle.sh" => "xtitle"
    bin.install "xtctl.sh" => "xtctl"
    man1.install "xtitle.man" => "xtitle.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtitle --version")
  end
end
