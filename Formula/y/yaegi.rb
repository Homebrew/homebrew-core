class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "77f5e17b53796fe89dad92f016dee6599d95a2b985508263a711a772c4c9b9b2"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d57101d28414b81ef994d0642b4910804174a7b346179ff4345add58470fc28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4079400ee37d691ceaaecbac440d5d5b5b188b181b818583078aad7efb89dd76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35935341ca2bc46e5134bdc552751a437f706dbe1c7cc98eeacfccca3cc2473c"
    sha256 cellar: :any_skip_relocation, sonoma:         "95ef4d3c09e3be12d26a381610dd4978c8a6a6f4b10c988bbdaac55d6c715939"
    sha256 cellar: :any_skip_relocation, ventura:        "bf77b3a35251286d59d5f029b3ddfae1954f21e1a373ddab0e392f823614df8e"
    sha256 cellar: :any_skip_relocation, monterey:       "f6db1fabd03f00b13ca284466fdc91892da672ac986f0a57f709e61edca6d64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c978af552f0e951fad995b78651d9de3f5cd1b8a5e970ffef992c59a16eb568"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
