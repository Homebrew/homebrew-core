class Smenu < Formula
  desc "Command-line tool that turns its input into interactive selection menus"
  homepage "https://github.com/p-gen/smenu"
  url "https://github.com/p-gen/smenu/archive/v0.9.9.tar.gz"
  sha256 "04c9ea56130a8d2398c5fba712f6e099d7a7adb0d9072d1610624fe902b5c54d"
  head "https://github.com/p-gen/smenu.git"

  def install
    system "./build.sh", "--disable-dependency-tracking",
                         "--disable-silent-rules",
                         "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s.sub("HEAD-", ""), shell_output("#{bin}/smenu -V 2>&1")
  end
end
