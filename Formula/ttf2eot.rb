class Ttf2eot < Formula
  desc "Convert TTF files to EOT"
  homepage "https://github.com/wget/ttf2eot"
  url "https://github.com/wget/ttf2eot/archive/v0.0.3.tar.gz"
  sha256 "f363c4f2841b6d0b0545b30462e3c202c687d002da3d5dec7e2b827a032a3a65"
  license any_of: ["LGPL-2.0-or-later", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac0f37ff08692308c939a421e2d2ab2dfc7130d1bcc85ca070e1baab844dfcc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad7c55fc38097327fcc7ecc967f4af2a24ee690ffe8f1ed5e465f5ef398c4750"
    sha256 cellar: :any_skip_relocation, monterey:       "7b791e8df0d498383f11ccbed2017a57be517169725560b92ccd0d25ef602123"
    sha256 cellar: :any_skip_relocation, big_sur:        "88edb09b376fe32ce292747416549530e92a763c9859817e7eb936c65cf1c696"
    sha256 cellar: :any_skip_relocation, catalina:       "05b1f397b4784a77f36a3d3138e812932db4419d8d03e0f0735e58591677e918"
    sha256 cellar: :any_skip_relocation, mojave:         "54d328636bcb7d9fe1e28bf46115f0b718fc9f4d8e18c48b39d5b2e87bb3930b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7b44ec925ee2bbeeaba775befc77c0c22f2f690ecd94edb72e471c631da80f43"
    sha256 cellar: :any_skip_relocation, sierra:         "26f40d7a58de2ee396fc04dd47c41e9b65640570fa1ca8b71134dd88e6e88c06"
    sha256 cellar: :any_skip_relocation, el_capitan:     "5fc89e642b7d51c0c7965d9a952d1b697f94b4ec16d7711ff37387979ce47f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e9bce41da4284c7cb5a07cc7fa05f911457de66e3ddadf4b0cc1334773100d"
  end

  def install
    system "make"
    bin.install "ttf2eot"
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode" : "Arial"
    font_dir = "/Library/Fonts"
    on_linux do
      font_name = "DejaVuSans"
      font_dir = "/usr/share/fonts/truetype/dejavu"
    end
    cp "#{font_dir}/#{font_name}.ttf", testpath
    system("#{bin}/ttf2eot < '#{font_name}.ttf' > '#{font_name}.eot'")
    assert_predicate testpath/"#{font_name}.eot", :exist?
  end
end
