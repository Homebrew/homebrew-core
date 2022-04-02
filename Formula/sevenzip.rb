class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2107-src.tar.xz"
  version "21.07"
  sha256 "213d594407cb8efcba36610b152ca4921eda14163310b43903d13e68313e1e39"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7283890b7e26f7049acc6b39f4f39d0d0bb6e1d70cb06173bcef4c51e7ce9a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab906227f52335777f0da449a9cd4e26a5e4dd144bdd1bd8a1c717122f003749"
    sha256 cellar: :any_skip_relocation, monterey:       "16c9f1e8e2596337d06be004b9fc406a1268dc1ed0256fb2842bf9dde3644524"
    sha256 cellar: :any_skip_relocation, big_sur:        "dadaed910b2c853c75b965c25cfc7601c8bb4cac03ab98d53c5c9174d0088f4b"
    sha256 cellar: :any_skip_relocation, catalina:       "c627888d7cf8967a729cbc48d3b7f5576a296a96b29f5d17ad863a0e97550a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f227bae1087fa8b9523d9fcce434ce496201287f81a18c2a65668cca544e7f"
  end

  def install
    cd "CPP/7zip/Bundles/Alone2" do
      mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
      mk_suffix, directory = if OS.mac?
        ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
      else
        ["gcc", "g"]
      end

      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"

      # Cherry pick the binary manually. This should be changed to something
      # like `make install' if the upstream adds an install target.
      # See: https://sourceforge.net/p/sevenzip/discussion/45797/thread/1d5b04f2f1/
      bin.install "b/#{directory}/7zz"
    end
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath/"out/foo.txt").read
  end
end
