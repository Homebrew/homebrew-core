class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.7.0.tar.gz"
  sha256 "78c463152e1d9e4fd1bfeb83b9c92df5e7fc4c5f93c7d426fb1f7efa2be4df29"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rdfind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "140d7e72ac236159bb1912547d8c1981be0e3726d83d1c3497d56d2b7d68ea58"
    sha256 cellar: :any,                 arm64_sequoia: "3784a5af50fc5823d7f72461b520a54698c68c93ebdaec59189592f9fc23ebd7"
    sha256 cellar: :any,                 arm64_sonoma:  "f0afe789cfeaf5d4cf9eff52e075ae575de24cd6c2f16aec588a30bd6a3725ef"
    sha256 cellar: :any,                 arm64_ventura: "cc9fb51dc12b296700a3d4b2f91d0f913c16e9b187184458c2eb6847134f71eb"
    sha256 cellar: :any,                 sonoma:        "f53c9d56247f3c928409c3356c6028a30da6dc3438daa2b87664d748f28e2347"
    sha256 cellar: :any,                 ventura:       "4beb231157b8cd5f653402304d0060cc169587333d65afd1a7a8c164aa69c1a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c925d7eaab171bbc4c5e0e84df68bcfa9be1ffb00a6d1e2144340ab588a8896a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba451fc698fa746924d67f4966af5c02c6f354f8641d2ef1a24320d3f6a40b4"
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
