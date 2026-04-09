class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.8.5.tar.gz"
  sha256 "15284b6da609284606510b934a14aefdf01396b8d1e9631930b237b2403fd672"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "a663d39601f8dfecb907f30cdfb5e488ca4bc7cc2fc359fb0376374b9d9cac46"
    sha256                               arm64_sequoia: "05cf64c63181f55d8677524ba6a69cb99df04cf708e839aceac9b3eac65828ee"
    sha256                               arm64_sonoma:  "35cc53f7c62627945157bd725d30ea9ab3c02c2e3b8a2c449b081b288f203bcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd2d18dff97f2abfedf607ef2889a14a9f797ea2691a01b33ad743079294be06"
    sha256                               arm64_linux:   "ff1e6069b513181b9275c4cf451da043f24b1f53eec555fe4ecd202fca6c7b10"
    sha256                               x86_64_linux:  "2168df54851aee7e20427326d7e86ed0a9ff3b22b8a50e8af8894bae0946a444"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.8.5.tar.gz"
    sha256 "3b30b65fb6a01f456805639cb9cca09aa616506df307461e48d8424e35d03123"

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
