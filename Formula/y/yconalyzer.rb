class Yconalyzer < Formula
  desc "TCP traffic analyzer"
  homepage "https://sourceforge.net/projects/yconalyzer/"
  url "https://downloads.sourceforge.net/project/yconalyzer/yconalyzer-1.0.4.tar.bz2"
  sha256 "3b2bd33ffa9f6de707c91deeb32d9e9a56c51e232be5002fbed7e7a6373b4d5b"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4b34ab4323a8d42637c2b41ee0f30f76200bc29070a31db211f36d96e2522e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc908152c7c95c1f6849997b3f3ef3ea58dd1f4093b03a6d043ddaf0ed272156"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58d53e3cef900391c6b010c6e5e7a8643630155947068b9755bed061b46c94c7"
    sha256 cellar: :any_skip_relocation, ventura:        "91f17d0dc4ebdef21e2905a8f6ba20d465fd42b923904ff7ef86ff65a2f4c335"
    sha256 cellar: :any_skip_relocation, monterey:       "b44aa7bbb2dafbe58a1db1f4dfe228fc2cf7719e79f449185577817090d3a1a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e6c3b8964a0feb62dc624f9359bd48e44c07929b1952c36fbc4d05be76ef871"
    sha256 cellar: :any_skip_relocation, catalina:       "2e834b5134e7670fc97cb45131b732a7dc7a6f41598dacb20dd65b575713dc16"
    sha256 cellar: :any_skip_relocation, mojave:         "d5b2345a94b2590f9f533f30d3770cc2008ce294fd8c56015f025181ba951b35"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4341ba620cc2724608dea783a2ddbd3bde93fd2017cc675e906f233941fb4ab3"
    sha256 cellar: :any_skip_relocation, sierra:         "3bf190ad069a4ee9423e79415907a684320e8e776916329f46d7620274a03434"
    sha256 cellar: :any_skip_relocation, el_capitan:     "918ca6d2bca328923ec3ff6e5612e9a0336aad666e993cfb0d1bc42a99758f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c416d91d76c10a6331d9703d23597b5e03fb67c97155247cb6e5e3f852f89953"
  end

  uses_from_macos "libpcap"

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
