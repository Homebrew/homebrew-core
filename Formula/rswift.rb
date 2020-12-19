class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/v5.3.1/rswift-v5.3.1-source.tar.gz"
  sha256 "5e9283474cb21bddf1f75f7a4615610900f9db0c396919f8130bac3b7475fa67"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15c3981e13142737733a6e678de443503cc3feec3bd87914c93f5673515faa35" => :big_sur
    sha256 "11bfb864afdbd8bb30b490fd36be26409a091039d286992ae9f0f287b80540c6" => :catalina
    sha256 "3ed20c92efdfb3094dc303c5ba2be1607b697ead9c4e0d0ed77622fb01692284" => :mojave
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
