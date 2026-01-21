class Ttf2eot < Formula
  desc "Convert TTF files to EOT"
  homepage "https://github.com/wget/ttf2eot"
  url "https://github.com/wget/ttf2eot/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "f363c4f2841b6d0b0545b30462e3c202c687d002da3d5dec7e2b827a032a3a65"
  license any_of: ["LGPL-2.0-or-later", "BSD-2-Clause"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d16324780cc0664cc3e5372cc1c6959062258a6480c23e4ca1791c0e0013f864"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a4063624dce85f67ce9f8d03c746e79350fd5ec24b3439cdef46e71bf1f07418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04c47f19d3aaac57af033502618dc069f0145102dc4296c17afd5ec871cdddeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "867b5d7d37b4ac230168ea41318dd3a6f9fed7b64dba3f6aed2e57ac3f89d9a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac0f37ff08692308c939a421e2d2ab2dfc7130d1bcc85ca070e1baab844dfcc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad7c55fc38097327fcc7ecc967f4af2a24ee690ffe8f1ed5e465f5ef398c4750"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa65afa0cca03bd779972063ad68340335fc8411e9af7ce3f18c684a4f0059eb"
    sha256 cellar: :any_skip_relocation, ventura:        "d2f96c1fb256084ee3ac130861a7a72ddf03841ff45414dada9ec4d04acc1241"
    sha256 cellar: :any_skip_relocation, monterey:       "7b791e8df0d498383f11ccbed2017a57be517169725560b92ccd0d25ef602123"
    sha256 cellar: :any_skip_relocation, big_sur:        "88edb09b376fe32ce292747416549530e92a763c9859817e7eb936c65cf1c696"
    sha256 cellar: :any_skip_relocation, catalina:       "05b1f397b4784a77f36a3d3138e812932db4419d8d03e0f0735e58591677e918"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ac667f059eb2d3394c7869f8475a60d36840d7d94992557178974b10166b80bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e9bce41da4284c7cb5a07cc7fa05f911457de66e3ddadf4b0cc1334773100d"
  end

  def install
    system "make"
    bin.install "ttf2eot"
  end

  test do
    if OS.mac?
      font_name = "Arial Unicode"
      font_dir = "/Library/Fonts"
    else
      font_name = "DejaVuSans"
      font_dir = "/usr/share/fonts/truetype/dejavu"
    end
    cp "#{font_dir}/#{font_name}.ttf", testpath
    system("#{bin}/ttf2eot < '#{font_name}.ttf' > '#{font_name}.eot'")
    assert_path_exists testpath/"#{font_name}.eot"
  end
end
