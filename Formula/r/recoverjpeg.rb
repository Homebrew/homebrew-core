class Recoverjpeg < Formula
  desc "Tool to recover JPEG images from a file system image"
  homepage "https://rfc1149.net/devel/recoverjpeg.html"
  url "https://rfc1149.net/download/recoverjpeg/recoverjpeg-2.6.3.tar.gz"
  sha256 "db996231e3680bfaf8ed77b60e4027c665ec4b271648c71b00b76d8a627f3201"
  license "GPL-2.0-only"

  livecheck do
    url "https://rfc1149.net/download/recoverjpeg/"
    regex(/href=.*?recoverjpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0cf49dc7323f9987a3d847fed81edc56edd45ff8e14846c7bf9de6cc4cb360cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d5246787a0e2678f90c0df0da8f43a4eb2de1ec4ab3fcc6398f66854db6571ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8acee12074e5c4e6990042383385e5c4056e35ec43f1ee39a779768f5720a0c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f34e1452d02fd2e51fb1235a43821519c7811eaf0dea534429901ef2f948921"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b65d282127e64583e422741ae3d2980cfbd7dbc8a471fa05e3a39dea3d7efd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68e1a85a85e46ac4b90b093c36f9e461e6566351518b76891ebd3283b95fa8c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f425281c6489f684ab9ba7926410b5e7e5acad81218c3115883ef0d6a4d4efa"
    sha256 cellar: :any_skip_relocation, ventura:        "e0a2345c5293d9afb7e754028ed2707c443f78bdea6c43f34ea1a46ca0d24a52"
    sha256 cellar: :any_skip_relocation, monterey:       "a9043bcada2749bee2dd525f6aa3919cff2f45f2290234ec6302f7985acf3399"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd56d3048f05834faf5181f4372fe49a8ef3895c291fe0ca2a434a416e305495"
    sha256 cellar: :any_skip_relocation, catalina:       "87b3d9adf8b59d91350b7e655a78b68525caaaad0a614c5b7e1b6097d29cf6d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d6b4d36e75677621fc7e3f1749d0fc475aa660c5057d1cbb8c5e83eea8cda0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a89fb65c4850f34a1885cd95da2fbd669f1af300fbbf940b5271c97551c9ce7"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recoverjpeg -V")
  end
end
