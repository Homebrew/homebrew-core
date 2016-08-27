class Rebar < Formula
  desc "Erlang build tool"
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.6.3.tar.gz"
  sha256 "e4b645747bcc1cde3994ccc7a3861a97408df9be387ea1e7bc8910cd013154e0"

  head "https://github.com/rebar/rebar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e51dfc5ac0ce56aeb1e379c41f4e66bba94fb64c838a633621a3f261325eeee8" => :el_capitan
    sha256 "bae2f489f7ae55758cec1b6fc0851ccc079074fd3f677284cae4623db4e4af1a" => :yosemite
    sha256 "9173f08dafd976e28fe03b34875976a0090829b9d5ffe5e7fe555e6c5c1a4eb5" => :mavericks
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
