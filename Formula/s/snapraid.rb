class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v14.2/snapraid-14.2.tar.gz"
  sha256 "57da8c813b12dd91bfa5b145b7529f84e227a301394da109fa64f39479c14a1b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d10794b0ca2b81a7ef269666bdc3951df97133c2ddff0c7dbc09fc0229c9703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae1ff335221758dceb6cd7ae388df4b3fb3e10fffdf4a5c3864befeb89ab8ba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "759562eb7d8616c0ec6dae79d8b8eeecf7d57ac1e49bda497f3238581c96b8ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "2203cc8b6623ba60fe2f14847bb82dd1736063508c7d3d1778ccbe3a9b89b05d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b730a630546d4d8e608e54ba7de60aa19093a089e3e967ebd2536de6898f5408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418c6814165bfc98b1b3b940ba5b2cdc6ad9a37f8d78fad02df87709bea3311f"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
