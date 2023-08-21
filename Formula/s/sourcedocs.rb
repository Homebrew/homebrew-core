class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/SourceDocs/SourceDocs"
  url "https://github.com/SourceDocs/SourceDocs/archive/2.0.1.tar.gz"
  sha256 "07547c929071124264ec9cc601331f21dc67a104ffc76fbc1801c1ecb4c35bbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbe4a3e5c3485101486be0639b81cc4799c2dd7e0edf5f528d32a3c0ca6122fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8757a91d73d96999da362afbc5a5c42c7be949f562cf5569b2bf24853af6ef9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1254fb0f47a037f929e579b4a68dd375b0e587d9adb3e876865b6de031d39f46"
    sha256 cellar: :any_skip_relocation, ventura:        "5cf36d5bfe2a9a2770454f21169e5e9c8a5a6b50525ec0a9418c88180706d40c"
    sha256 cellar: :any_skip_relocation, monterey:       "974904c0b5b4d0d54fe8392c84fe06b3aa23e47fb76f95579f09e5fc94704d2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "292dbf6713d17716e685ac74c0e9fdbe07038b95bca36f234a94bfe2fffe5aab"
    sha256 cellar: :any_skip_relocation, catalina:       "56cad5d1e01271614fd93c5ec93b4b7fc7cabb64bef767581bc5ad179ee20a63"
  end

  depends_on xcode: ["12.0", :build, :test]
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/sourcedocs"
  end

  test do
    assert_match "SourceDocs v#{version}", shell_output("#{bin}/sourcedocs version")

    # There are some issues with SourceKitten running in sandbox mode in Mojave
    # The following test has been disabled on Mojave until that issue is resolved
    # - https://github.com/Homebrew/homebrew/pull/50211
    # - https://github.com/Homebrew/homebrew-core/pull/32548
    if MacOS.version < "10.14"
      mkdir "foo" do
        system "swift", "package", "init"
        system "swift", "build", "--disable-sandbox"
        system "#{bin}/sourcedocs", "generate",
               "--spm-module", "foo",
               "--output-folder", testpath/"Documentation/Reference"
        assert_predicate testpath/"Documentation/Reference/README.md", :exist?
      end
    end
  end
end
