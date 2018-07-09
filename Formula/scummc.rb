class Scummc < Formula
  desc "Set of tools allowing to create SCUMM games"
  homepage "https://github.com/AlbanBedel/scummc#readme"
  url "https://github.com/AlbanBedel/scummc.git", :revision => "b947f61fc9f550bcdcf66e771fc36795b6cd3687"
  version "0.2.0+20171206"
  sha256 "6eed5d773a2b7de912c15cbfd3409d82939e08769dd559a22c63558e541093ac"

  bottle do
    sha256 "1de93783f408c2cfc634d8f13c8cb7db1e2544d021f15e0484e64a92af2ed3db" => :high_sierra
    sha256 "bd2da4d91eb4e0f8fcf69ad9383a89979c73e539f1b1a5df8d7d99dc01fb67c5" => :sierra
    sha256 "26dce34185c67fe8034effb99e248b9b68344063194ccb20c8c166b2f6c58dfb" => :el_capitan
  end

  depends_on "bison" => :build
  depends_on "freetype" => :build
  depends_on "gtk+" => :build
  depends_on "sdl" => :build
  depends_on "readline" => :build

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
    system "#{bin}/scc"
    system "#{bin}/sld"
    system "#{bin}/cost"
    system "#{bin}/char"
    system "#{bin}/soun"
    system "#{bin}/midi"
  end
end
