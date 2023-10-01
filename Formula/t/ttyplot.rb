class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://github.com/tenox7/ttyplot/archive/refs/tags/1.5.tar.gz"
  sha256 "c494c31e7808a6e3bf8e3c399024b9aeb7d77967db6008a62d110ad9ed1b8bec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c24df0685dc076f14dcd00fa961d3c6c6a446a221271a069631c6daddc3d1aa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "767a44e685f2079d82454f7a4e7fc6d56d6b402f3a82df88ef00989d9b31098e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "863baa45ba7f5ab1aad586332f76c91fc6210bf6dc6ceb1af7d40a5cdddd7f6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a39bab7eb01b6f56fbfbb48f519a1bcc15ec1eedbf72197572aa55913fb11cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "3103a2439ec90049b6945544b76e094809b3e6cf82ab42c1510775c7f5322c9e"
    sha256 cellar: :any_skip_relocation, ventura:        "39258c0803f33905e7ab7aa5a76f3192fcba5b15f955a7b7e7a27ce9e5e45bd5"
    sha256 cellar: :any_skip_relocation, monterey:       "bcde373e4c5603d06be8fae27214d7869705e2bd419961e3d056160b2833b246"
    sha256 cellar: :any_skip_relocation, big_sur:        "987e9fa6aa9238163f994e245c1c2004faba72ec110a09cc237b5257cc5dbd1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b2c7594e230dce7c24a66d6745d0be3bb6d137b2ace6da15447f97939460ccd"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    # `ttyplot` writes directly to the TTY, and doesn't stop even when stdin is closed.
    system "#{bin}/ttyplot", "--help"
  end
end
