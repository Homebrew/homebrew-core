class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.7.2.tar.gz"
  sha256 "7e93d28e81c3e95ff07674a400001d0cdf23b7842d49b211e5582d00d8e3ac3e"

  bottle do
    cellar :any
    sha256 "be63f1db40715777ed72c20e5a75b0491e863dda33d7ba2ca825f256b3f80ef4" => :mojave
    sha256 "9b4aad450dcb6469088b53d53d305da3ad300245767f93d8709c9ccddc1e9e86" => :high_sierra
    sha256 "61ceabdb6921692f69f1f51d256ffde7c88b86b58283471ee005ac7806d2cf5f" => :sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match /^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt")
  end
end
