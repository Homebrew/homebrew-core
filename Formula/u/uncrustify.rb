class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.net/"
  url "https://github.com/uncrustify/uncrustify/archive/refs/tags/uncrustify-0.80.1.tar.gz"
  sha256 "0e2616ec2f78e12816388c513f7060072ff7942b42f1175eb28b24cb75aaec48"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca9b30a47c171cae16d7332361d1e4e7a3870df19257cf19459ebfd3044bc7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "157a68626f5eede2f37c574b0dc920eb94a084f42de04e2419e6ad277aa6e221"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8dc2eb428f5d4cb4ca7f302074859c88e1c8b4ced9b61811ce89866c1bbb09ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95b0762b9ae4860c58a0f776e54f6cbe7cc0a722b6501e8671debc6b131f53e"
    sha256 cellar: :any_skip_relocation, ventura:       "547a9696faaf9b80195e72ace9a0caf59d68ad0394e5aa2862cb43017c66023a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fd1e80df05f05e200787dadf2be03a4ce475f6166c505184f4364cf9a79f3d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab2a6cd25ee6ef310d75e2052933f6779cbf482c2f52c01f32aba887a5901cd"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~C
      #include <stdio.h>
      int main(void) {return 0;}
    C

    expected = <<~C
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    C

    system bin/"uncrustify", "-c", doc/"htdocs/default.cfg", "t.c"
    assert_equal expected, (testpath/"t.c.uncrustify").read
  end
end
