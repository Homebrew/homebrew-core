class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2406-src.tar.xz"
  version "24.06"
  sha256 "2aa1660c773525b2ed84d6cd7ff0680c786ec0893b87e4db44654dcb7f5ac8b5"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)\s+\([^)]+?\)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25a26d942075907ee2f64e69fc29cf7d6049c6674454655de1f045305f102501"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7277ee861ec06916bc028555b6917d372a6fb48fe22ff8a66e0c5318e03eef2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83f2ed3f17d91a75bd8aa3e8b48518431deeececd9df6cf729268413b593e283"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed81465cd1f65b69b446173ed5f25712466b6d85a378859b019e1265c3bbf84c"
    sha256 cellar: :any_skip_relocation, ventura:        "4509aa51944dfdcee68b48eaa11115a74a5ad9e8ec0da4523e783702f8f9655c"
    sha256 cellar: :any_skip_relocation, monterey:       "9aaa2990bdf5b92e334c5bc8898263ef18eff154fa3017e1b08e0606e592be3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "143dcafcb221aef159b9b8c4800ef467075f30c4068b16309ce3c54c683884bd"
  end

  def install
    # See https://sourceforge.net/p/sevenzip/discussion/45797/thread/9c2d9061ce/#01e7
    if OS.mac?
      inreplace ["Common/FileStreams.cpp", "UI/Common/UpdateCallback.cpp"].map { |d| buildpath/"CPP/7zip"/d },
                "sysmacros.h",
                "types.h"
    end

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
