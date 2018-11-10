class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.6.0.tar.gz"
  sha256 "d1a8e3b6a0c13fa7f91c41d6167611513cccd0acf130f659e6865597ef5f18b1"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cee542502f7455a41011ffcaaa050ecfd53fa65c9cfa04e86565525383cf8600" => :mojave
    sha256 "63d6071aa8743fb1b596adbe070bacc309f041ac8fc63a25cc9afdb98ac77fee" => :high_sierra
    sha256 "2b6be3da62abec1a9809065c463582338bf30d836404fc4b64a71eaeb7a6b3f7" => :sierra
    sha256 "13b18dce374485d0608859d77c3c7bc7232b13a39c51cdd0c54d05cb9488c0a1" => :el_capitan
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
