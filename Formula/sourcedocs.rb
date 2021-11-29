class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/eneko/SourceDocs"
  url "https://github.com/eneko/sourcedocs/archive/2.0.0.tar.gz"
  sha256 "da33b0186d6b1ea07b67cbdf666d2ea91f55a9892557b47b1d6e2f1abec3dd44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "06b1e8ad009967c2c97ce74d7df61a17797f5aa8a15b23f2cfd9041158219d77"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1f7e8ecf73fd06ca1b1f79814f5d4bbac116060cd0abf58039af3d0c8e10d73"
    sha256 cellar: :any_skip_relocation, catalina:      "9bdc9f8b2d42d2f66251a5f201ff4d978dd96030d726dc924e3c1928b70bf91a"
    sha256 cellar: :any_skip_relocation, mojave:        "d0f79030518567fa2fee422afa683015191440dfca26b4e3a5718b79502a9d49"
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
