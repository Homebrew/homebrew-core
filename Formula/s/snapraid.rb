class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v12.4/snapraid-12.4.tar.gz"
  sha256 "bc15ad9c42ddf9bd70033562a10e9b9fec43afed54c48fe22da4b6835657ec1b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be651a06a787a34c2a61ec630533c9f797466f39e08263b20001f9847716410f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3584f9baf7c68d40594c5cd6e55f2673673c89e9cee864761189841ae1618d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fdcfb27a1c6b992091984301b37490227c5d76e4c29b0c185f013b056589ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3db986583cb40047356a50b2f930e584cfecb08acbbf1fece8eefa126613dcd9"
    sha256 cellar: :any_skip_relocation, ventura:       "525798bd506d2e33f10e5732f919aca3886106df15d02b42338600ad717a4756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e06bbc388fc22c7502f614c6489c5f6ec7e626000054dcb870cbd4b9be557467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e1a40ce144a059183f2fa5e2e070bd27e41340d4329feae564eb2aefefe5cd3"
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
