class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-4.3.1.tar.gz"
  sha256 "de488c6bfa0312412a746e3a59e2de21e81c0859372faa68f30a393b8c12de02"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia:  "2ff81de36045bc09bd06610f11bd977ac7ddbbcd99e5673b1558c45a84cc18db"
    sha256 arm64_sonoma:   "8d62e9dd770ae6253e8b62e6071fd260a16f08629157aa9ab746b34f6a885890"
    sha256 arm64_ventura:  "19865d303128dc729deb227669c1ca31c6083735faeb0ca78bfbfe26ebc7c087"
    sha256 arm64_monterey: "1dc929d0d92e334942a582a1119ae23cd9cc8c77a4e7073fe82d3d018148be06"
    sha256 sonoma:         "509d5bdd8a367008ecc4c46d83ff7dd7f86e22b932112c2b8773d59e23121a13"
    sha256 ventura:        "4567d4c03fa42a832e87f8779e54c8416ce472002a47b3087900b62652c2d6e3"
    sha256 monterey:       "5fcc95b371f6c45da66a8aa3fd3ca6c074e2fdb92bb620430006fe56c1494026"
    sha256 x86_64_linux:   "d7020b43b3311e9a681aecb68f2aa3f8df53bab59dd99b31dcb708d2f613b4c0"
  end

  depends_on "cmake" => :build

  resource "homebrew-testdata" do
    url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
    sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
  end

  def install
    system "cmake", "-S", "./cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    system bin/"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}/verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}/output.svg")
    end
    assert_predicate testpath/"output.svg", :exist?
  end
end
