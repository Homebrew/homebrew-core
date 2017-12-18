class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.12.tgz"
  sha256 "9d35c7414493faae79fb60866966862c58c2f37eefe08e77d226ecbd6d7acfa2"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fd39bbf9f70cda9312604756dea52f39861e00da467fc2c4ab579bcf319e030" => :high_sierra
    sha256 "967f09662001e1fa07500bb5355ac807d059850057bf32fc38b8fd38e5e966d9" => :sierra
    sha256 "64a85a3a261d1e31cf3d0f3289f9dbc8275cc78c43a0bd49e1c6995897a331b9" => :el_capitan
    sha256 "7d36ab2640514fd21ae733c2c9f93ce94dad7e5523963f7c2318a4680cfb2fe2" => :yosemite
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
