class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/1.0.1.tar.gz"
  sha256 "763d5a5c9219f2084d5ec6273911f84213e5424f127117ab0f1c611609663a8b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9288dfaf7d55197fd3468953aa278104a1b3d35750bbb77803cfe18131dcf292"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1e41bc669f9d931347a38ccbbb391a2db5010060f05851a3145af651ac76052"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0766f40464ad75ead48f2ac1715964054845b3d04c118c3a6c72cd1745057862"
    sha256 cellar: :any_skip_relocation, ventura:        "183fd627b878d49ac32869d77cb076fdb2a747e714ec04ef6458fc494ff13dcf"
    sha256 cellar: :any_skip_relocation, monterey:       "f7356f10891390e057d8c134e2938012411b7acb3f5b9753639c1e702f5dc08e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e012c6b51e806c00b198bfd359c3f64b815380f8ffff6193910382ed02d14e7e"
    sha256 cellar: :any_skip_relocation, catalina:       "9833ede83c62d4d39396dd15dcca7f595277dfd7c08f1be4cf29d86d24f97b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1cd66774457486f7ebfdc066ec5af7109b8894aab60ac07e9419436408314f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rpg-cli").strip
    assert_match "hp", output
    assert_match "equip", output
    assert_match "item", output
  end
end
