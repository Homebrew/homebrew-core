class Scummc < Formula
  desc "Set of tools allowing to create SCUMM games"
  homepage "https://github.com/AlbanBedel/scummc#readme"
  url "https://github.com/AlbanBedel/scummc.git", :revision => "b947f61fc9f550bcdcf66e771fc36795b6cd3687"
  version "0.2.0+20171206"

  depends_on "bison" => :build
  depends_on "freetype" => :build
  depends_on "gtk+" => :build
  depends_on "readline" => :build
  depends_on "sdl" => :build

  def install
    # Requires Bison v2.7 or later
    # All supported macOS versions ship with v2.3
    system "./configure", "--bison", "/usr/local/opt/bison/bin/bison"
    system "make"

    # There currently is no way to specify an build folder
    # Default naming scheme: build.<HOSTNAME>.<COMPILER_VERSION>
    bin.install Dir["build.*/**/scc"]
    bin.install Dir["build.*/**/sld"]
    bin.install Dir["build.*/**/cost"]
    bin.install Dir["build.*/**/char"]
    bin.install Dir["build.*/**/soun"]
    bin.install Dir["build.*/**/midi"]
  end

  test do
    # TODO: Write meaningful tests
    assert FileTest.exists?("#{bin}/scc")
    assert FileTest.exists?("#{bin}/sld")
    assert FileTest.exists?("#{bin}/cost")
    assert FileTest.exists?("#{bin}/char")
    assert FileTest.exists?("#{bin}/soun")
    assert FileTest.exists?("#{bin}/midi")
  end
end
