class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.net/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.77.1.tar.gz"
  sha256 "414bbc9f7860eb18a53074f9af14ed04638a633b2216a73f2629291300d37c1b"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6a60728012c42571964e51a3cc4cb04a887e89368fcb8cf7e910cac81a3cfe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27a67f8a91b6281144ea19ba3da33d02c17d4ff901b0a20ec95f86a2d5076cdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afd522877248c5ce7c20718aa662a45da10d1efce0c1c276e904cf83957216b0"
    sha256 cellar: :any_skip_relocation, ventura:        "dd3bb8e3ac1e6b9dccc027c92ba497896b28b1bbbe066bfbddc97aaed32bb307"
    sha256 cellar: :any_skip_relocation, monterey:       "90581bb3e2dce969a539afc186f4130e104b892a902972eccbb2330e8f3d2d3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f73c1607cc1c4cf15e28339dc36d9ed59338dfd34e1c910e9ebbd556de578eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13707a10791840a3cf9b43c650caaf7265b3409dbc4bd56bbd8433f7c22fd4b0"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<~EOS
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end
