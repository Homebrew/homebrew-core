class Stdman < Formula
  desc "Formatted C++ stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/2021.12.21.tar.gz"
  sha256 "5cfea407f0cd6da0c66396814cafc57504e90df518b7c9fa3748edd5cfdd08e3"
  license "MIT"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af6eae23fad722d838b7d4a68938d3cd187a0e18e5b54cfa3a3d48c9ce85cd08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ddc1b9f0ee3a49700119c961ecd84cf41411ed67a1ae92a8f113cd67537326e"
    sha256 cellar: :any_skip_relocation, monterey:       "4bfe62a6de41be881f882b575f84cf2150bdd8256067a98429837f38712a9207"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f41a799a0b2127509c19ddd4f166ea89e37c51c3904eba2844e6c64f863fd08"
    sha256 cellar: :any_skip_relocation, catalina:       "e3ea4278fde0a38a7b8857e9a238464382ec7c8262b768a05f1730fd98e4daa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2291feacb728c6580e6da646023abb24450d360160bb365233a7803e25f5deb"
  end

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    man = OS.mac? ? "man" : "gman"
    system man, "-w", "std::string"
  end
end
