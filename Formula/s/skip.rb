class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.8.11.tar.gz"
  sha256 "1b0e4445286aa2bf07057bb5b8756114b1339a7295319d05fa823506db1c23a2"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "1e0a1f7db8590b4286fb00f6bacf79c82baee0bc3ea70bd3385d65cf4d4a489f"
    sha256                               arm64_sequoia: "81dfe1f19bb585fdcd4853f7c6459490f7b087f3a3901c2c5de14b3b0b809d4d"
    sha256                               arm64_sonoma:  "96a41adbfdb2ecbf1cf4a29a34df2342d40c15a1285ff602f9ac06f2aae4fa20"
    sha256 cellar: :any_skip_relocation, sonoma:        "09c895578dcd65d23ef6fa602421239ec0459241ac1ecadcbf4f8082b209e252"
    sha256                               arm64_linux:   "bf8625a158930ddfb4e4ac1b69691275d53545cc03d2e09102d534f4a1eb6917"
    sha256                               x86_64_linux:  "bced1589c0b9ef3b53e6d21b8ed597b5d1e5b720c1415a3f92b85a666c40ba12"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.8.11.tar.gz"
    sha256 "31cfec3e0cc6b41d3f029cbb6afedfe69526f50847993e00331b504b48af6543"

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
