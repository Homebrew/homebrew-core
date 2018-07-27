class Scummc < Formula
  desc "Set of tools allowing to create SCUMM games"
  homepage "https://github.com/AlbanBedel/scummc#readme"
  url "https://github.com/AlbanBedel/scummc/archive/v0.2.1.tar.gz"
  version "0.2.1"
  sha256 "1d9b412d7ab6197495589a19a4745f58b35a002e26cea21bf6874a7ae4f1fd2e"

  depends_on "bison" => :build
  depends_on "freetype" => :build
  depends_on "gtk+" => :build
  depends_on "readline" => :build
  depends_on "sdl" => :build

  def install
    # Requires Bison v2.7 or later
    # All supported macOS versions ship with v2.3
    system "./configure", "--bison", "#{Formula["bison"].bin}/bison"
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
