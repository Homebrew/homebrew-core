class Rpl < Formula
  desc "Text replacement utility"
  homepage "http://www.laffeycomputer.com/rpl.html"
  url "https://web.archive.org/web/20170106105512/downloads.laffeycomputer.com/current_builds/rpl-1.4.1.tar.gz"
  sha256 "291055dc8763c855bab76142b5f7e9625392bcefa524b796bc4ddbcf941a1310"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286dbe82c334c92999af55394d6ae990ece5617563f39afe1d7e5d1e7b0510c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ef9e4c29ce913017b65e176d38f3d7b1a3ab33147c0fafb270cb7b442a2d78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66905494cd9a1dcff546a819ed9be8dc20113323ae4dc339d346359e8f4752dc"
    sha256 cellar: :any_skip_relocation, ventura:        "c199985afc0139e5a97ba13b719537e1423aa821c424f20af11dae0e78a133d9"
    sha256 cellar: :any_skip_relocation, monterey:       "ec1ccbe3b7a0b822464cbd586bb247a0c5ef5f72781c9a9ec7aabcd0e0169348"
    sha256 cellar: :any_skip_relocation, big_sur:        "b07f269aff8704908beb57b9f6045daaf377805371ca4edc72e362cab4fb7e23"
    sha256 cellar: :any_skip_relocation, catalina:       "edbab26552da9547f8d356ba50bb2d02ce6c10549da2c2c4d5f65a3bc4039b81"
    sha256 cellar: :any_skip_relocation, mojave:         "79ed79d50ceaed30cc0fedaeeead5742208c72b04858863ceaf7951c7cbf8e00"
    sha256 cellar: :any_skip_relocation, high_sierra:    "70b23d5ce18f2dfe58e8c782a00e4ab56d88c1e43b135c9e9ba0c8c387bef470"
    sha256 cellar: :any_skip_relocation, sierra:         "2c9e55b51762d835db949c20f9eba36e83213082db82c69602658e2f28003b80"
    sha256 cellar: :any_skip_relocation, el_capitan:     "175e1f127c8c707b0d90c3c7e4399cc5c1e18410bf8b7f6ec9340dbca4c16e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d343c559dc0109ebc9ea3c19568ab9a6aa222feeb21c3b94e6f17c98f67f76e3"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
