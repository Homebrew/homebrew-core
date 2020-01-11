class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.0.1.tar.gz"
  sha256 "4cca3d8a40e5132a4764a3bf7bcf335288ebff8a4a74e130f9359605e6f07544"
  revision 1
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99a851ba828b0f4ffc8749b75e73f5cb6bd1a7ae482881f80dba33b8f478559e" => :catalina
    sha256 "142441307ad8c014c3f46fcf9f4bbd8d708efc535ae7e98611cf3f332f4c6c86" => :mojave
    sha256 "5a143415c3e1a6846976258d2dc04e172b3df54d35c37296f3c07f0f4bb7ecd8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags", "-w -s -extldflags '-static'", "-o", "#{bin}/shfmt", "./cmd/shfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
