class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/v5.3.1/rswift-v5.3.1-source.tar.gz"
  sha256 "5e9283474cb21bddf1f75f7a4615610900f9db0c396919f8130bac3b7475fa67"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "795ba1b73f962b695dadce31ea8c4a133e1640cb47a3d66e3f1610e120e8d6f0" => :big_sur
    sha256 "0336661379cd6634bc68e0d863932724247416c24abd44fa5ad0eff10cbce234" => :arm64_big_sur
    sha256 "171e1c4edafbafc0eb0435c237bfb5ede731e76b537d3282e995f5c3fb6b30ad" => :catalina
    sha256 "607dcfb0fb765913d682438997b09ce512c0a5e9c8ae53ae957f4b5997ccd47e" => :mojave
  end

  depends_on xcode: "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    assert_match "[R.swift] Failed to write out", shell_output("#{bin}/rswift generate #{testpath} 2>1&")
  end
end
