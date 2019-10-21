class Yconalyzer < Formula
  desc "TCP traffic analyzer"
  homepage "https://sourceforge.net/projects/yconalyzer/"
  url "https://downloads.sourceforge.net/project/yconalyzer/yconalyzer-1.0.4.tar.bz2"
  sha256 "3b2bd33ffa9f6de707c91deeb32d9e9a56c51e232be5002fbed7e7a6373b4d5b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2e834b5134e7670fc97cb45131b732a7dc7a6f41598dacb20dd65b575713dc16" => :catalina
    sha256 "d5b2345a94b2590f9f533f30d3770cc2008ce294fd8c56015f025181ba951b35" => :mojave
    sha256 "4341ba620cc2724608dea783a2ddbd3bde93fd2017cc675e906f233941fb4ab3" => :high_sierra
    sha256 "3bf190ad069a4ee9423e79415907a684320e8e776916329f46d7620274a03434" => :sierra
    sha256 "918ca6d2bca328923ec3ff6e5612e9a0336aad666e993cfb0d1bc42a99758f1c" => :el_capitan
    sha256 "e3e3fcebfdd0d25fbdad33c8f2aa13976c70ab4ff4bb81ed1fbae5cb8a7c2ffd" => :yosemite
    sha256 "c2c6d2a81a8b13515192b716bac7df7db078e986f8306d37d3b4da5a2f05ccd6" => :mavericks
  end

  # Fix build issues issue on OS X 10.9/clang
  # Patch reported to upstream - https://sourceforge.net/p/yconalyzer/bugs/3/
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/yconalyzer/1.0.4.patch"
    sha256 "a4e87fc310565d91496adac9343ba72841bde3b54b4996e774fa3f919c903f33"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    chmod 0755, "./install-sh"
    system "make", "install"
  end
end
