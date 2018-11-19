class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.6.1.tar.gz"
  sha256 "faa1a40964744508b737a2c536f01e74e96162f30ac12f967656fa272d292c53"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b99e24282e65da9ad2221e2d07f42ed64bef0b2ad5b5fc7b9ed7124b8acf238" => :mojave
    sha256 "381a97ded56d0bc6122961f66a4dfa830d4a27e953e2ff885be0750a4a4d94ef" => :high_sierra
    sha256 "85787eb5a48f99283bd1afdb82daaca4d021aa0d47055e65a8846e1f83417040" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-o", "#{bin}/shfmt", "mvdan.cc/sh/cmd/shfmt"
  end

  test do
    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
