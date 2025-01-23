class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.6.0.tar.gz"
  sha256 "7a406e8ef1886a5869655604618dd98f672f12c6a6be4926d053be65070f3279"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rdfind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e4c5ee4e3e0e82d1de65d7a31db48d82aa7b4da10433f91a31cc0c1e9c960652"
    sha256 cellar: :any,                 arm64_sonoma:   "3823096b8f3b320247c7a20986a2923511aaddc13582d6d1be176f7a0a725d3c"
    sha256 cellar: :any,                 arm64_ventura:  "ac61318405080ae930560042e69a95081d0ef43bc78fe6f7e197af8739242924"
    sha256 cellar: :any,                 arm64_monterey: "3beae55c25f4c3e1b0b8167baf0b627527666563a38cd3f5fe4f880a3a2de69d"
    sha256 cellar: :any,                 arm64_big_sur:  "d857d69934703cbe1b03e9ff6e8d6fcbdb005f80494f12826fea7d2f4ad84645"
    sha256 cellar: :any,                 sonoma:         "4557ec686306c8ed652ce55b72aa4e360e558e5968727a981ebe019acd67eb0c"
    sha256 cellar: :any,                 ventura:        "d3d563d4bb4a22d77747cf8885aec7c6d0a80d5eeca9913fc84f85388f729b9f"
    sha256 cellar: :any,                 monterey:       "a07aa01be6a114670e2e58e052d286cb15bf82ab70ceaf112884a16d99f8eaea"
    sha256 cellar: :any,                 big_sur:        "19afda77102d68f9f15b821fe67c9f2fb43220924fbe3ae900bae6269d4667e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8ac064985f32311bb3a467b0d5c8dee97896164a2a877d8eda74d02a133e4d5"
  end

  depends_on "nettle"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "folder"
    (testpath/"folder/file1").write("foo")
    (testpath/"folder/file2").write("bar")
    (testpath/"folder/file3").write("foo")
    system bin/"rdfind", "-deleteduplicates", "true", "folder"
    assert_predicate testpath/"folder/file1", :exist?
    assert_predicate testpath/"folder/file2", :exist?
    refute_predicate testpath/"folder/file3", :exist?
  end
end
