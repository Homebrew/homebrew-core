class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.10.tar.gz"
  sha256 "086adb1b2bb5bf2715113af025ff1bd72555c64eb8023acb126c66edac9cb89c"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3658d0a57064a7337623c6aba74e06413c2f8b586b3cabafca39a7353fbfb297" => :catalina
    sha256 "3a12722a82af54893ca3e79ac713a53649cfa692e86293719e8e174574c1759a" => :mojave
    sha256 "ed60eaa1ae16be71d2052ad8a24a708a1bb9b7d9fae9b819745ed99ef1a4f112" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
