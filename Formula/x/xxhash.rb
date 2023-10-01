class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.8.2.tar.gz"
  sha256 "baee0c6afd4f03165de7a4e67988d16f0f2b257b51d0e3cb91909302a26a79c4"
  license all_of: [
    "BSD-2-Clause", # library
    "GPL-2.0-or-later", # `xxhsum` command line utility
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bd633f463f984a4c366688ee42195a6382d68452b10261b6d66e5b42b946846"
    sha256 cellar: :any,                 arm64_ventura:  "13882b17bbb0bcd1b7c79ebe1912a4ab7460256b544b16931cf4fcf8cb947e86"
    sha256 cellar: :any,                 arm64_monterey: "20b06ae306d9b5364b62e5303945bbfde04e5c22881732d39ae45fd458b62f71"
    sha256 cellar: :any,                 arm64_big_sur:  "ec987574c874ebbd84368f57d3170fba6d30aa41d597e5a6b436c2f1d78a013a"
    sha256 cellar: :any,                 sonoma:         "51b03a33f7ab2802da5372a9e3f7c0c925fa30c6cf01f5177165196e4e3cae4f"
    sha256 cellar: :any,                 ventura:        "6fffb4bf9e00679944422235a4b4ce24f453afb04c4fd13dbf37e8d5e604b976"
    sha256 cellar: :any,                 monterey:       "0c4059783709ed691e988a52b2185a690e43c1d1a9539e8a545f5d74d91995ac"
    sha256 cellar: :any,                 big_sur:        "8bbc412ee6ee5cd0e118696bd1b04aca009dae53a0b6b8f9a4b871ab6c3050e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e06b5f020744b6b5cfb7787f85fdd05fcbd7731573b7ca26d8c4a4270aa2e8b"
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
