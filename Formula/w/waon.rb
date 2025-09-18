class Waon < Formula
  desc "Wave-to-notes transcriber"
  homepage "https://kichiki.github.io/WaoN/"
  url "https://github.com/kichiki/WaoN/archive/refs/tags/v0.11.tar.gz"
  sha256 "75d5c1721632afee55a54bcbba1a444e53b03f4224b03da29317e98aa223c30b"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ba4c8874a6eeda9339d900073289cd829ab0bb0ca156509b141e3ff20fa9d432"
    sha256 cellar: :any,                 arm64_sequoia:  "10296a60dfeda8e84d9d66f0bbce71ca7072f3a108936537aedabb4108f1e9bd"
    sha256 cellar: :any,                 arm64_sonoma:   "7b3a144f5378ada22f1510604e3c49057031d6003769d97ccb8deee748b874e5"
    sha256 cellar: :any,                 arm64_ventura:  "648dea99dcc66856eb8a50ae15b4f8b026be97accb83bdceaabe795933b63af1"
    sha256 cellar: :any,                 arm64_monterey: "42e529969e77de03e3dccc5c7e8ea1883bb860f22cc253b710a2d0125f0648df"
    sha256 cellar: :any,                 arm64_big_sur:  "5c2460bd2671fbb035d30f61a80c470caca47d2cc2b84b103b1d9d25540dd233"
    sha256 cellar: :any,                 sonoma:         "40676016b9dc97fd7e1af31a12d79e6bd59608f1751a3a1df31b8e07843f4d71"
    sha256 cellar: :any,                 ventura:        "0cac05703864bf3fa9a3d7b5df3707eed37ed165926b63c9fe8fac3c3814427c"
    sha256 cellar: :any,                 monterey:       "5c75aa3dabee6f46d25c3ac932ef5af20f00cfefe4e5e586489c380ed9aa4c05"
    sha256 cellar: :any,                 big_sur:        "1fb554284ace79c0c8eae1d7dc9b9e9ce9d7d90e35e97ad318f5cf7dcdaa059c"
    sha256 cellar: :any,                 catalina:       "47eaaeeea5b323dced48d444ffc21c2f16b86443271952bceac22abd788ebd8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "da0153186a47b6bbf4df39692da5552c67d68f455c1fe36fb2c13dd811106571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f91b56d77254441ef842600da7b63b3ec7f84046cad6d89c64314aafa82af1e2"
  end

  depends_on "pkgconf" => :build
  depends_on "sox" => :test
  depends_on "fftw"
  depends_on "libsndfile"

  def install
    system "make", "-f", "Makefile.waon", "waon"
    bin.install "waon"
    man1.install "waon.1"
  end

  test do
    system "sox", "-n", testpath/"test.wav", "synth", "3", "sin", "A4"
    output = shell_output("#{bin}/waon -i #{testpath}/test.wav -o #{testpath}/output.midi 2>&1")
    assert_match "# of events = 2", output
    assert_match "n = 2", output
    assert_path_exists testpath/"output.midi"
  end
end
