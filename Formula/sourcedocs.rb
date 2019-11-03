class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/eneko/SourceDocs"
  url "https://github.com/eneko/sourcedocs/archive/0.6.1.tar.gz"
  sha256 "335f49a0488c8bd792ec4e459663b4fb878065430eed92b37ea3498d1f9165cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "08a7d9f4ec9a51c0bd4830d29fa3c268accb90f3b8243adebfd6000df3429cfb" => :catalina
    sha256 "c04ff3cb4611ca1c230f5ebc1108977e5d51f1918fe7d1936134c455a7a1a93f" => :mojave
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
