class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/eneko/SourceDocs"
  url "https://github.com/eneko/sourcedocs/archive/0.6.0.tar.gz"
  sha256 "38726a965d65caa4bc7e89208fd7f2d2cac7422106302bb23007965e5e1e0ea8"

  bottle do
    cellar :any_skip_relocation
    sha256 "256b06c1425620af744d17bac21d993c54f12f1543206ae08b29e09fe28d1fc5" => :mojave
    sha256 "7a7c4205340af10ab3cb41ea097f3be5fcf134c461c84869216b568aaa86b429" => :high_sierra
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
