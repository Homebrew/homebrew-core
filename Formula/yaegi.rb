class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.12.0.tar.gz"
  sha256 "caad3b3f2272aa31c8a853a383a2199fc7fc11d54e186bd3dbb80ced6da64e56"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "827d118bcd1e205c6fc7e5e31bd6efaec628c16c4e7289b86426922d4d2e9506"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dca5101dd81e6243629cca9788814c75988b775230d5564fa047a71b2a8ce8d"
    sha256 cellar: :any_skip_relocation, monterey:       "65d4fd34d037f1412344655397c44980125f043ba0b4e77c0d2df14239baf338"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdef900d47c60cb90039109a222a0053fb30b979c92abed2a9386508e4015f0c"
    sha256 cellar: :any_skip_relocation, catalina:       "2749d8b7b7b227d21995907856e2648c3f2ca2e690acf91070392661a3ccd8a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c2e7729b8065d1a4f57ced852da9ee8584b3445f1bd7bef3e1a0cb8fbfe2181"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
