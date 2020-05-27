class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/eneko/SourceDocs"
  url "https://github.com/eneko/sourcedocs/archive/1.1.0.tar.gz"
  sha256 "cf3df9522f66d7a89c0a4291c0b9dd63cfaacc12c1f4210a792d55bcfe8d59cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "709fe9bcd8d9bf1cb5285618983eb6934807eb1c58d893d0576e7889815d9a03" => :catalina
    sha256 "ae52c1dcdd808cb5da7bf34f0b293c25056df18308ed95754b0f9cef0a4fabfc" => :mojave
  end

  depends_on :xcode => ["10.3", :build, :test]

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
