class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/eneko/SourceDocs"
  url "https://github.com/eneko/sourcedocs/archive/1.2.0.tar.gz"
  sha256 "edfbe37a267be4d5ddd795c74522dcbb72b6fd42e11a0922c3ad87f4bac0e55f"

  bottle do
    cellar :any_skip_relocation
    sha256 "32bc59646532b362651b126946cbf051a90b2b1da5d07a614d50fc0b0bc1efd1" => :catalina
    sha256 "3bfe25d253eecef289c822012efddc14d9bd331eba0f3f54fe88e7d0cf2aa924" => :mojave
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
