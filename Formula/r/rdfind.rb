class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.8.0.tar.gz"
  sha256 "0a2d0d32002cc2dc0134ee7b649bcc811ecfb2f8d9f672aa476a851152e7af35"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rdfind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d2979a97f519fb423e4f2cc675228adadfaf06eced01ebca1e9f4e29937780a"
    sha256 cellar: :any,                 arm64_sequoia: "e28f7b8a870e48477982f7584422dd10c5b7dafbfbce7fab8e6f0e0f5ad87d2e"
    sha256 cellar: :any,                 arm64_sonoma:  "79893eeaade7d4af2b3b33947bdc40110fda3560e6eff298bd7b52c7f7797986"
    sha256 cellar: :any,                 sonoma:        "f3e153459e13432a6d1846e8a64e8068f146be76e709a600040a899f8f0c3718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4d0cf4a553fc36c215dbcedf00665f18a00ac1ee39994e6f651b91bac5ca59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6259eb0eb7fae1bb1180e27e1978a2fe98f268d9f3a1dc5e8378b4ad440ee7da"
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
