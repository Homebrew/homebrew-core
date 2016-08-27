class Rebar < Formula
  desc "Erlang build tool"
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.6.3.tar.gz"
  sha256 "e4b645747bcc1cde3994ccc7a3861a97408df9be387ea1e7bc8910cd013154e0"

  head "https://github.com/rebar/rebar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6138205d90151d23256a7b4b35636378cdd80561ecfc06000310d8b3aaabc3b6" => :el_capitan
    sha256 "8f23d08a9f9cd2921c0d492bc193fd9120cb0960e872f6cfcca4a55b8f3202da" => :yosemite
    sha256 "95ee34b3f97814b6d9b77881b50ddf743b7381912ab8658ff06b9d95fe377127" => :mavericks
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar"
  end

  test do
    system bin/"rebar", "--version"
  end
end
