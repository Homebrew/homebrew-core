class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.1.3.tar.gz"
  sha256 "7139e5aa9892f030dce55817a662e7c0b490d6fd16a60410f5abf1ba00f3826d"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e012881ad07b5493991c62d4e830cbad1ccf16896c1551892b396ea2a92d0c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3607a7cbab48a5412badfbbd7df9a884121b9a24eaf919c600ccf52e64b7a0c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "33e260721d234835d1fab9b95e3ac4d348036c200ee3ccd1f2586261394a4de7"
    sha256 cellar: :any_skip_relocation, ventura:       "6542a985047226fd43d53a185807229581a9953cc36a4e22a58fbe51ffd50445"
    sha256                               x86_64_linux:  "13c0e0a831aa4cfb64059d541f9dcb01c9af5fa6655496c5aee0f61b4f1ca41a"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
