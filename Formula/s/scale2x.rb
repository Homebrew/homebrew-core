class Scale2x < Formula
  desc "Real-time graphics effect"
  homepage "https://www.scale2x.it/"
  url "https://github.com/amadvance/scale2x/releases/download/v4.0/scale2x-4.0.tar.gz"
  sha256 "996f2673206c73fb57f0f5d0e094d3774f595f7e7e80fcca8cc045e8b4ba6d32"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "fa827e146d2d3caae2e059081469d5a6e95c275692c515fe591e7a1c8ad3bb01"
    sha256 cellar: :any,                 arm64_sequoia:  "15f0e0d3d8c68339cfd69eacf4c0fe5ae65ddb27e69ce289df33875c730b4559"
    sha256 cellar: :any,                 arm64_sonoma:   "74863678d188209041dd4746830686ec7a93f2acf7dc492d647ca8f3d23802fd"
    sha256 cellar: :any,                 arm64_ventura:  "bff379927979a35d8106edb039f4654afee5c4d973fd26a2b1f6d6a6979540ed"
    sha256 cellar: :any,                 arm64_monterey: "fdc15180cc28f6677f0a14647292744970707eb9e0302bbc95ec65f902f935ce"
    sha256 cellar: :any,                 arm64_big_sur:  "f7d4ecfe86027e9aec4928c84ba6262e7f8633796ed3317da93a2d8b2e1a5b58"
    sha256 cellar: :any,                 sonoma:         "4624fcd2273c59bcd3fd3fe1f7de3daa02e5ff3a5b6bc43b0de3362e5519c429"
    sha256 cellar: :any,                 ventura:        "ec4ecdb490fb74e96b3192a475d2c0069d075af72cd24a8ae7dd93dd6546d168"
    sha256 cellar: :any,                 monterey:       "8a91f909eb5e0d332c7718e47a59fd45dc74625d3828049a2819a55f24226f6d"
    sha256 cellar: :any,                 big_sur:        "9ba9679c817187ca44e3074c102572781ad4e90abb1aa8a41d452e5d6814d046"
    sha256 cellar: :any,                 catalina:       "83ab737ffb44b1b2913244a82c63d754057e79034bcf455d75b9150b630f85c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f8b10c78d54037bfcf02fbfd70f5c32767c22005efdd14b6f19d9d08cd817ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8c30b93ecb6bf66a18c8004a6b56ca9ab4fc074fe4e433439f3bd49ba944005"
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}", "CPPFLAGS=-I/usr/include/malloc/"
    system "make", "install"
  end
end
