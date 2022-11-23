class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.6.1/roll-2.6.1.tar.gz"
  sha256 "399bd4958d92f82fb75ff308decb2d482c9a8db80234014f6d42f6513b144179"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ffc7291577ef075aa3c1369419b6d92389b19ad6cd0d841bc613f3eae48c016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a8e1ac1b898c674f5a752ca03e7952d011f7b115529d3ab1f92f745392ecfe4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14b4457a32902e96d331fca1fd85fbbf3d5f515914091da2c61dec741bf3d73b"
    sha256 cellar: :any_skip_relocation, ventura:        "88ea735366f98e1790c9fe70e9de10138bfbc064a255820d8d8dc684a5bbf912"
    sha256 cellar: :any_skip_relocation, monterey:       "6f3f061734bc251d233b72aa805dc1cc3d7865e276c3e3c6c75854686ac06fdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "123c5c66e945afdfac73b0cf5b553df895c8b03ac22c32124ab6ff98e52e3478"
    sha256 cellar: :any_skip_relocation, catalina:       "c62fd4ce38c97e3f2a41203420feda3601359815a4cf20a6d68e3a9aa37bdcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e98554d4358ec561afd285196543baf10606cfcb0a6b842ba4949cf7b477894d"
  end

  head do
    url "https://github.com/matteocorti/roll.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./regen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/roll", "1d6"
  end
end
