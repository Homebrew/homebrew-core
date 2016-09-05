class Rebar < Formula
  desc "Erlang build tool"
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.6.4.tar.gz"
  sha256 "577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07"
  head "https://github.com/rebar/rebar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "786e311b5c1c1e72bb36e2473fdc5a052d271150e9ed385bff855281066d339f" => :el_capitan
    sha256 "12e12c685b444b97dcf8a2b47febb774cee580154cf3271c314d6d65a5a5b597" => :yosemite
    sha256 "b6360c3b82dfa1bc8e64fe9bdeb1fe0a73262b2784204b8fe3d488a5ccdbc486" => :mavericks
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
