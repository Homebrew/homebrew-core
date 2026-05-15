class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.8.0.tar.gz"
  sha256 "0a2d0d32002cc2dc0134ee7b649bcc811ecfb2f8d9f672aa476a851152e7af35"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?rdfind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63db8993c5a89ab61c517545b2eb85d4a5a6334c8b735c7c60c37ac043ba8b71"
    sha256 cellar: :any,                 arm64_sequoia: "80b66c742f116218d2044f1375328cfd758580e3ccca3d158b72d3832ed8b106"
    sha256 cellar: :any,                 arm64_sonoma:  "30d86306c8a3aab465037a111b0e3154e81e269376bc349a91a5a3af7be34f14"
    sha256 cellar: :any,                 sonoma:        "463efa01de978dc751b6f4e53f31c69b9508e4f676e7b58432b96a43dae2eb9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b477ba9491cb671cd48d2fbaa90898bded997d92a38909b93faef8ef92d1bf8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de313de0fe1ab06c00b90a9c7a58c8b2d4b227b4322478cbbffc10e5c5a7dece"
  end

  depends_on "nettle"

  def install
    ENV.append "CXXFLAGS", "-std=c++17"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    mkdir "folder"
    (testpath/"folder/file1").write("foo")
    (testpath/"folder/file2").write("bar")
    (testpath/"folder/file3").write("foo")
    system bin/"rdfind", "-deleteduplicates", "true", "folder"
    assert_path_exists testpath/"folder/file1"
    assert_path_exists testpath/"folder/file2"
    refute_path_exists testpath/"folder/file3"
  end
end
