class Showkey < Formula
  desc "Simple keystroke visualizer"
  homepage "http://www.catb.org/~esr/showkey/"
  url "https://gitlab.com/esr/showkey/-/archive/1.10/showkey-1.10.tar.bz2"
  sha256 "f4b4ff9c9655401483c60c1be6f19326560e62e854092477be037a3bb2b7fbde"
  license "MIT"
  head "https://gitlab.com/esr/showkey.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4db0ec95cc9b593dd603119093cc1cfb0d05fec67165b381bc936269aa11519"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b7eb7df2a48d0b831c30a17e94c1c2cbd2559649b697ca1e8214e1c5cca463e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e19b2b40cda59155d145ce44dba870fa1972a705df17027b2038619857ab58"
    sha256 cellar: :any_skip_relocation, sonoma:        "f28b228721672ae9f5c4e05e52ca7298e53a989ef9bed4b1720c15e726f9a5c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef382c4cc6e4d30291318ea81a45d774ee25654bf90ea7759550aa571b4ebf50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad609524ed5343ccfe3a417185d10446aaa70ac0b0ac291a20dfa793d25b4822"
  end

  depends_on "asciidoctor" => :build

  def install
    system "make", "showkey", "showkey.1"
    bin.install "showkey"
    man1.install "showkey.1"
  end

  test do
    require "expect"

    args = if OS.linux?
      ["script", "-q", "/dev/null", "-c", bin/"showkey"]
    else
      ["script", "-q", "/dev/null", bin/"showkey"]
    end

    output = Utils.safe_popen_write(*args) do |pipe|
      pipe.expect(/interrupt .*? or quit .*? character\.\r?\n$/)
      pipe.write "Hello Homebrew!"
      sleep 1
      pipe.write "\cC\cD"
    end

    assert_match "Hello<SP>Homebrew!", output
  end
end
