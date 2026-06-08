class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/refs/tags/2.5.0.tar.gz"
  sha256 "07f3c2d1215b82eb56ebfeb676b5e3860c23a828c14fd482c7c1935817f3220f"
  license "Unlicense"
  revision 1
  head "https://github.com/mxcl/swift-sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0a9ff13a99469ab189deb4388cfaa4f2519367b8aee3e9016f4f31a10515f43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "548765a57eec4a8a0ad39eb4dc096edd45c1c97a781658c52fd86e28b8c936d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96521fbeb28a32d2663b9219b95aab9c0c05853f47dd5afc6871f3626de31df1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c68d0216ef02718872c9f7947441000d6cdda72cec6dc137ca45eb8ab580430"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcdbf8f07f26f137a6e67ff2a8e0b28b3a682d7ef72715d098ade8653a28ffff"
    sha256 cellar: :any_skip_relocation, ventura:       "5d1400ffcbae6faa9bb66ce62915972758d4028b19686e2e927abd42b0d1b227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a267119c862d631a803769db55835b27d91a6a143bf1c9182e44922734bba16f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71745bc8b439b6b0f689f0f00a2973060c1962e7591f8bc65ccd82b61de8fd76"
  end

  depends_on xcode: ["11.0", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-sh"
    bin.install ".build/release/swift-sh-edit" if OS.mac?
  end

  test do
    (testpath/"test.swift").write "#!/usr/bin/env swift sh"
    system bin/"swift-sh", "eject", "test.swift"
    assert_path_exists testpath/"Test/Package.swift"
  end
end
