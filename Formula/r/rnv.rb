class Rnv < Formula
  desc "Implementation of Relax NG Compact Syntax validator"
  homepage "https://sourceforge.net/projects/rnv/"
  # TODO: If new release/rebottle, then remove `, since: :tahoe` from dependency
  url "https://downloads.sourceforge.net/project/rnv/Sources/1.7.11/rnv-1.7.11.tar.bz2"
  sha256 "b2a1578773edd29ef7a828b3a392bbea61b4ca8013ce4efc3b5fbc18662c162e"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "294d562f37f9fcbdfebca1f0ac3a304e5c749022dd1287a35b847b2223ad9a07"
    sha256 cellar: :any,                 arm64_sequoia:  "c2d6586422e5ac938d5f27b00ba89881fb64e07b84250b44ac5905bd7189bd92"
    sha256 cellar: :any,                 arm64_sonoma:   "150d0eecdd925b7dd54064578d8e204e0cfbb1575ea100ba13168e2b4e22f4eb"
    sha256 cellar: :any,                 arm64_ventura:  "86e6bfd85e0678347eaace39bb3ad203e08f8006c84939fa9a41e693ee6c1326"
    sha256 cellar: :any,                 arm64_monterey: "bf6a467df397afc6d6ffe8e54dabb5f41eb47f71b75fba32e19e6b6d0e297029"
    sha256 cellar: :any,                 arm64_big_sur:  "8901e5d1b3915babeec29f4485afa741d41b2b48946515c1d871f525512ae1b6"
    sha256 cellar: :any,                 sonoma:         "3ccd0c89d06e4b941388b087171a7fda820d4bab2243a173ff4854bf161eebb8"
    sha256 cellar: :any,                 ventura:        "6648abdfb9856bb6aadfe9f24e54ba9dd64ee636bbf817b19e5386014c1336a6"
    sha256 cellar: :any,                 monterey:       "6e53766114e84c2d465873f78f4d8e9989186297140dae5966927b966d821d8e"
    sha256 cellar: :any,                 big_sur:        "c262efcf45b880c131f5e466d1b672ce5120dff6302b9b7504f6c1e1ee87cb22"
    sha256 cellar: :any,                 catalina:       "9a780a7b9ed3b264a7d0471aba7aac503b60640af76156028ecf118a0c35665e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "607237d06383c7a8da2bfa731d52f960d9a9a35ccd465dfee6fcddc485e42d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3368e22e32650a6594df96320a449717d447a25d69a8485c907f1e0d10a1c49d"
  end

  uses_from_macos "expat", since: :tahoe # to preserve old bottles

  conflicts_with "arx-libertatis", because: "both install `arx` binaries"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.rnc").write <<~RNC
      namespace core = "http://www.bbc.co.uk/ontologies/coreconcepts/"
      start = response
      response = element response { results }
      results = element results { thing* }

      thing = element thing {
        attribute id { xsd:string } &
        element core:preferredLabel { xsd:string } &
        element core:label { xsd:string &  attribute xml:lang { xsd:language }}* &
        element core:disambiguationHint { xsd:string }? &
        element core:slug { xsd:string }?
      }
    RNC
    (testpath/"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <response xmlns:core="http://www.bbc.co.uk/ontologies/coreconcepts/">
        <results>
          <thing id="https://www.bbc.co.uk/things/31684f19-84d6-41f6-b033-7ae08098572a#id">
            <core:preferredLabel>Technology</core:preferredLabel>
            <core:label xml:lang="en-gb">Technology</core:label>
            <core:label xml:lang="es">Tecnología</core:label>
            <core:label xml:lang="ur">ٹیکنالوجی</core:label>
            <core:disambiguationHint>News about computers, the internet, electronics etc.</core:disambiguationHint>
          </thing>
          <thing id="https://www.bbc.co.uk/things/0f469e6a-d4a6-46f2-b727-2bd039cb6b53#id">
            <core:preferredLabel>Science</core:preferredLabel>
            <core:label xml:lang="en-gb">Science</core:label>
            <core:label xml:lang="es">Ciencia</core:label>
            <core:label xml:lang="ur">سائنس</core:label>
            <core:disambiguationHint>Systematic enterprise</core:disambiguationHint>
          </thing>
        </results>
      </response>
    XML

    system bin/"rnv", "test.rnc", "test.xml"
  end
end
