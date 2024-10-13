class Tarlz < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/tarlz.html"
  url "https://download.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.25.tar.lz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/tarlz/tarlz-0.25.tar.lz"
  sha256 "7d0bbe9c3a137bb93a10be56988fcf7362e4dbc65490639edc4255b704105fce"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/tarlz/"
    regex(/href=.*?tarlz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "73fed788316637043bda1e64c407149dde1977a6a275779707704d3189b402d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "724ae61a60f4b858328dabb04ea1c8a96d5ac3992f7b1b4915dde4bca22ec907"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f4ee004dc11788230bf475c8a45aa88693d8c8e2fd5a73c6df973defaab3beb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "818cc5f0bce8a9a6b2a0710a70f17d406de307d365bd3395ad624ec4a0649d7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "769cbcce323ad82b3321cf3ac067c1be49c9a81c1f1dd2f7397aa416e70aa1e8"
    sha256 cellar: :any_skip_relocation, ventura:        "287f2d4b7a60a4bdd500f8ffabeaa260fe0df60f8b7501d32a872ceccd7dcb7a"
    sha256 cellar: :any_skip_relocation, monterey:       "bbce39b7d5de4e4c66032f715c382e779bcfa9746e37815d2a85118595664b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e7441fc058e0e2de405d0ba720d32fc416eda8ba88db5ff75254ff0c2e3d74b"
  end

  depends_on "lzlib"

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    spath = testpath/"source"
    dpath = testpath/"destination"
    stestfilepath = spath/"test.txt"
    dtestfilepath = dpath/"source/test.txt"
    lzipfilepath = testpath/"test.tar.lz"
    stestfilepath.write "TEST CONTENT"

    mkdir_p spath
    mkdir_p dpath

    system bin/"tarlz", "-C", testpath, "-cf", lzipfilepath, "source"
    assert_predicate lzipfilepath, :exist?

    system bin/"tarlz", "-C", dpath, "-xf", lzipfilepath
    assert_equal "TEST CONTENT", dtestfilepath.read
  end
end
