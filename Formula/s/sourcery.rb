class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.3.0.tar.gz"
  sha256 "097aa2628cfbba2f8c2d412c57f7179c96082ab034fc6b2a2e905a0d344269e6"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d293720e393e8f1cdb9934480c57c2988197b8687866647d852007cd306bb532"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b00239a0776854f00ea97b0f39f7427a0d1918b262a1e9870c0609e8ad3704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bebaf580a1245a2252b45bfe47f2379fbf1b45a6d9d719519e34c3f5082f1396"
    sha256 cellar: :any_skip_relocation, sonoma:        "3195f7b0b2da7dc65223012c8780d00967bf4e77eaef7c65b883b1d63d7a2be0"
    sha256                               arm64_linux:   "6db97b372c4ec3fb2d91b02d84a63344cd812abc10a7f59064204ca30121f977"
    sha256                               x86_64_linux:  "521ecc8ae4d51e5a43935abaed048f64b7738b0e88291606d0bc38a4eaee0ade"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    # Build script is unfortunately not customisable.
    # We want static stdlib on Linux as the stdlib is not ABI stable there.
    inreplace "Rakefile", "--disable-sandbox", "--static-swift-stdlib" if OS.linux?

    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
