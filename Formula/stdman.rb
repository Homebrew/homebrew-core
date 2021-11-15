class Stdman < Formula
  desc "Formatted C++11/14/17 stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/2020.11.17.tar.gz"
  sha256 "6e96634c67349e402339b1faa8f99e47f4145aa110e2ad492e00676b28bb05e2"
  license "MIT"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b50938eda0d0261c75c92c9099680a4279d0c336439151b83753b9a2b373637"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f865e4982fe6eeb4674df33b984ad994c863d26e1ef209c13ed688ae2bda30b7"
    sha256 cellar: :any_skip_relocation, monterey:       "bb4ca59df0ed17d602d400151c6016fd3dcf60d8b6525478ba4fddc8b791b405"
    sha256 cellar: :any_skip_relocation, big_sur:        "72cfb38a8ed45c88a2a70cf75029fe5be4e53e18a19a85e532a482714b68d32a"
    sha256 cellar: :any_skip_relocation, catalina:       "4cffe0f6e5f997fdef7932ca12d10f1d0a0501f659028a277166e9e1678a93a2"
    sha256 cellar: :any_skip_relocation, mojave:         "741674ceaa66f53fd98c146dc1123c63d981997c4ef7bf171f671d83f8b87959"
  end

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "man", "-w", "std::string"
  end
end
