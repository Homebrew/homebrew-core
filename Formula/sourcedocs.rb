class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/eneko/SourceDocs"
  url "https://github.com/eneko/sourcedocs/archive/2.0.0.tar.gz"
  sha256 "da33b0186d6b1ea07b67cbdf666d2ea91f55a9892557b47b1d6e2f1abec3dd44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d3730a6201e7102e8fa8aef6b508c6282a7d60c5b9d943b9f018e6064c226d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ca543cee2f31b2b31b8c350d81b6ce9267f61d6a9207c7f88543bbe3aca901e"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e95658761b582363d03147adaf13fd9d73d046224fcd2147dd495742b3e85b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdbd1e960a957e717691d8dde89643187b30af510ad6999c7183f0f43b4365a5"
    sha256 cellar: :any_skip_relocation, catalina:       "71442a1bb13f262c5aad88da184352ae817f15b18f65f17abf2dabc39d85ca40"
  end

  depends_on xcode: ["12.0", :build, :test]

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
