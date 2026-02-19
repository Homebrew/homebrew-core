class Termbox < Formula
  desc "Library for writing text-based user interfaces"
  homepage "https://github.com/termbox/termbox"
  url "https://github.com/termbox/termbox/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "402fa1b353882d18e8ddd48f9f37346bbb6f5277993d3b36f1fc7a8d6097ee8a"
  license "MIT"
  head "https://github.com/termbox/termbox.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "aa4f2e932f63b5801947e8ec51324138da823801d57cef26823a7181b3e05a0b"
    sha256 cellar: :any,                 arm64_sequoia:  "571090957f2e0ff1cc0bf2f15802e7e1585e769e14ebdaf2fd6ac649d5a26602"
    sha256 cellar: :any,                 arm64_sonoma:   "4f40420e806ed17a377452472803016909039a1d5054483e14bde23583ca2ea8"
    sha256 cellar: :any,                 arm64_ventura:  "1c91ef6f8297e7e77925b8810b50c495ee1fa90907aeafb540993c83421534a1"
    sha256 cellar: :any,                 arm64_monterey: "a1371f4a993d30d381ab3bf5ea2fda669e23f0ea982c3de4c6bf8b01a2ec1747"
    sha256 cellar: :any,                 arm64_big_sur:  "ed78a6e1ccf8220eea8b25a1d836c72eb3c505f01d1886e367dd4563316f7ac3"
    sha256 cellar: :any,                 sonoma:         "2138fecfc44c6b3f92ad9530596eb05e09a9bdade60ff9083a17e6714a4855b8"
    sha256 cellar: :any,                 ventura:        "1fa6ac18b01cd55874c1cb9e1d0cdc2e83a017a0888dfed8a1417327fc6c5faf"
    sha256 cellar: :any,                 monterey:       "b1f84d69e57749e830ca1b95c627a8a0eae4f743c5fda140f6c73df685cecd57"
    sha256 cellar: :any,                 big_sur:        "31e50d5d18789baf3012c36fc3230e7268b044db64c7466e9c1b2ac5e0d62eb0"
    sha256 cellar: :any,                 catalina:       "1366318342e7c939466f699a6d5116b8d5581af33bddc0724d4c9a622e1f0d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "51e61e4ce516638b93e670a942c60310e5a13b23fa40eda6c17d554e6bb555e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96b1a190d17aaf736b5a592ef9a594458d58871360af83cfea7823881d4a1a1d"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <termbox.h>
      int main() {
        // we can't test other functions because the CI test runs in a
        // non-interactive shell
        tb_set_clear_attributes(42, 42);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-ltermbox", "-o", "test"
    system "./test"
  end
end
