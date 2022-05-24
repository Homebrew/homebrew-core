class Qprint < Formula
  desc "Encoder and decoder for quoted-printable encoding"
  homepage "https://www.fourmilab.ch/webtools/qprint/"
  url "https://www.fourmilab.ch/webtools/qprint/qprint-1.1.tar.gz"
  sha256 "ffa9ca1d51c871fb3b56a4bf0165418348cf080f01ff7e59cd04511b9665019c"

  livecheck do
    url :homepage
    regex(/href=.*?qprint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f17bf6ccfb63afc8908771488d0b1ffbbbdad4a3575c0654fe11e031c89ef0a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05903a905caebf80944f4705898c5377849b7a411cf234614205b3136dba4a38"
    sha256 cellar: :any_skip_relocation, monterey:       "0cadd8be56fb57e11e69c2a144bfc204e36298458c71d327d5d76abfddee2e9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "500367c9c89f50739d2b09f37f72ba1e0ec5418398d4570bf51363a725f57189"
    sha256 cellar: :any_skip_relocation, catalina:       "081c0663cccb890326323fce7ac57b8bb020d3505eaf0d19f1824dd63c304de2"
    sha256 cellar: :any_skip_relocation, mojave:         "0915aa3e8b8481b717c4c84b0eda595821ecc99c9ffdcd0aa3e4952a3de9ae87"
    sha256 cellar: :any_skip_relocation, high_sierra:    "57950dba66674d62c84076374427f6c3de6d8cda81448c50b579c11b1b1959e4"
    sha256 cellar: :any_skip_relocation, sierra:         "f26387daf3d025dd45843784dd90fb3bf77609bdf0eb870f1b66782c89571950"
    sha256 cellar: :any_skip_relocation, el_capitan:     "9660443356a1f9571b39ea496349482e17f7c0d06829dd06945ca7680291c0bf"
    sha256 cellar: :any_skip_relocation, yosemite:       "92470bcb0bd97c4d13181969ebeb0339faa85338ad139bf4a5ac19550635f5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adea30e44e1c128bf4f466fbca2a3eaad7f71bd90a9868492b8365611bb76489"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    msg = "test homebrew"
    encoded = pipe_output("#{bin}/qprint -e", msg)
    assert_equal msg, pipe_output("#{bin}/qprint -d", encoded)
  end
end
