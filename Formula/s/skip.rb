class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.8.13.tar.gz"
  sha256 "7dde4265e63bd17fa503e567e9114248bcc69f13280174a3615fe476c29a6362"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "45f4ac3868b619d29d2561267ad5f42c67f8fc788d047a267bbc61f0772f5a81"
    sha256                               arm64_sequoia: "9e3cfea11c52af01501f74efbbb3b5e6bb3309c2a7cb97c2acf118ddc745b97f"
    sha256                               arm64_sonoma:  "147dfff8c74d2bde21074d8098fae7d049a64e204216ed2593be80f086f1b54f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6f155513ed0111b06c8e5fe81a5378f1060a76102384623108f9d10aa7ce5a3"
    sha256                               arm64_linux:   "00999a137b9b73fb96d2a35150342c608ec64e690b8491a5c9e39ec5ec381f43"
    sha256                               x86_64_linux:  "56bf605eb13b8e09ac12ed76da23a3ea065ad4785ad516bb2d072e8db68562aa"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.8.13.tar.gz"
    sha256 "7e1d7ea3f481a5d2c0259135b230c40dcb1339d4401301b9c43c5dd8789779fe"

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
