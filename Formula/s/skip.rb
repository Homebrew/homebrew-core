class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.8.14.tar.gz"
  sha256 "34bcc44a0dd55fd52d0a1e62f4acbe8dd7bcb74fe1f2dc1ba1e47b48cf726276"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "9d38ca0eaccf38f4325983461ee954fceeca589c5613476769a44b7e01d16653"
    sha256                               arm64_sequoia: "223c6d70f6af8895fab7e01eabefc348b948c8d38dc6a7fa1ef20b48218a7d3f"
    sha256                               arm64_sonoma:  "a1414da008147750913a7dd8a0da2dc9f1f4b4dc9372dcd7f7c8af506a08e4c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ca9f2591b570fb2fdd7a24e4c16a405c824d84eb7f0c758488832ef4f05dce"
    sha256                               arm64_linux:   "7aac4000284fde39fb703676da0483f84b0516e4d7b1bf4ffa49704c9ba65b9a"
    sha256                               x86_64_linux:  "a7ac9513f95b11ad08ba40516182200dac00e6ba184ac24916e3d8bd8c797d08"
  end

  depends_on xcode: :build
  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://github.com/skiptools/skip/archive/refs/tags/1.8.14.tar.gz"
    sha256 "c3a9e8e5b4366e0201e4f9fed6959dcf9d570c502cf38c78c2784c0f7e0b4606"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "SkipRunner"
    bin.install ".build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end
