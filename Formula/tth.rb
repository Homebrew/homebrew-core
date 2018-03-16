class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.12.tgz"
  sha256 "9d35c7414493faae79fb60866966862c58c2f37eefe08e77d226ecbd6d7acfa2"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b06f95fbccf3847cbabee3dec070cae76763acef5b0801e0870359639a20880" => :high_sierra
    sha256 "22b58ab69a94f8e031efa6662179b14a2ba57bf0582174eda559abc0e3cf9701" => :sierra
    sha256 "d02002b9156fc175d253f30ac2e5e7fa29a32e3c109caeaa3367d33fa496eb8f" => :el_capitan
  end

  def install
    system ENV.cc, "-o", "tth", "tth.c"
    bin.install %w[tth latex2gif ps2gif ps2png]
    man1.install "tth.1"
  end

  test do
    assert_match(/version #{version}/, pipe_output("#{bin}/tth", ""))
  end
end
