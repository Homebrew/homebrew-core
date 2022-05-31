STARFIG_VERSION = 0.1

class Starfig < Formula
  desc "Starfig is a programmatic config generator. It helps create static configs using Starlark, a deterministic Python-like language."
  homepage "https://github.com/jathu/starfig"
  url "https://github.com/jathu/starfig/archive/refs/tags/#{STARFIG_VERSION}.tar.gz"
  sha256 "bf254452452b955cb70d95e4ae90b7242f4b811ed4c920fcf7acfe03a3782100"
  license "Apache-2.0"

  depends_on "go@1.18" => :build

  def install
    system "go", "build", "-ldflags", "\"-X main.starfigVersion=#{STARFIG_VERSION}\"", "-o", bin/"starfig"
  end

  test do
    assert_match("starfig-#{STARFIG_VERSION}", shell_output("#{bin}/starfig version"))
  end
end
