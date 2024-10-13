class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  # pull from git tag to get submodules
  url "https://github.com/YosysHQ/yosys.git",
      tag:      "0.46",
      revision: "e97731b9dda91fa5fa53ed87df7c34163ba59a41"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "150eebb45764504b9a880dd687cebd53b03bcefcde9d95ae94aa2f0208cd02d4"
    sha256 arm64_sonoma:  "4c8a43953c8c65268234ab6dd32faab5d77e1aafa02513601c665946599253f0"
    sha256 arm64_ventura: "fd87846951f944ee26825d5b7c4b169134edf5eee47cd2dd799f62a37ef1f5ac"
    sha256 sonoma:        "a4b36a3d497ac225130467786bb24aa33cfd2749026b3cdcfd1167bfa26b9c6f"
    sha256 ventura:       "aeba8681e8a94da79198633b8805fdd277084131f839bffb29ba5cce882440f9"
    sha256 x86_64_linux:  "0a2052e45f665a9dd64754613ed4466eaccdecdd37326ce2726105bc39e3d2cd"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
