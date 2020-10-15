class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/eneko/SourceDocs"
  url "https://github.com/eneko/sourcedocs/archive/1.2.1.tar.gz"
  sha256 "b37029b986055164297bc870e65e40672de05dc281f9e039f988e49a0bc00482"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bdc9f8b2d42d2f66251a5f201ff4d978dd96030d726dc924e3c1928b70bf91a" => :catalina
    sha256 "d0f79030518567fa2fee422afa683015191440dfca26b4e3a5718b79502a9d49" => :mojave
  end

  depends_on xcode: ["10.3", :build, :test]

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
