class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.8.1.tar.gz"
  sha256 "3bb6b7d6f30c591dd65aaaff1c8b7a5b94d81687998ca9400082c739a690436c"
  license all_of: [
    "BSD-2-Clause", # library
    "GPL-2.0-or-later", # `xxhsum` command line utility
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "daf4e0c7861f6ac2addb81a87f3b511fc972a332c517a3ea0ec00afb5558ae94"
    sha256 cellar: :any,                 arm64_monterey: "3d75964698a3beb04236d1632f6e69a2b58f1c552fee4720467c5ff47b1356b5"
    sha256 cellar: :any,                 arm64_big_sur:  "047255a58b02b965c7a8c1a7a6216bda9c0a386fd0847b019568de321ca81c27"
    sha256 cellar: :any,                 ventura:        "b20df383671e6eb2556e8cb31574382e6fdd58788ce843be1dbb0abcb601f6d1"
    sha256 cellar: :any,                 monterey:       "05eaeee75ca864298a1c85c6b917401bce6b429da391c83be347c321013f298e"
    sha256 cellar: :any,                 big_sur:        "7fbfb9c5e821cb3e373c44577f7839eb331287b84fb9ad56f048e98aff42a143"
    sha256 cellar: :any,                 catalina:       "b04f17e55ef5a2e48b0668453d0da1ec4af00752a62f12316a178f19b0f292b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1031dd4f8c86ee0e53242872aec9e4599be6b4f36c1ca58735651847f23c480c"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    prefix.install "cli/COPYING"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match(/^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt"))
  end
end
