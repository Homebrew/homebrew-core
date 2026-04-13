class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.8.6.tar.gz"
  sha256 "912fd4cef80c56efeeaddcaf4db97aba67b24883e0cc7262c36a03b8d50371ee"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "d23b823d5264269cc26cd39be2b732aa909d6d591e31124b1b4e96f820c0a2a9"
    sha256                               arm64_sequoia: "1974c295ab9745550197589ef0cb0dc4f7531d4abe37bfa4af6d5f371f0aa5cc"
    sha256                               arm64_sonoma:  "cf7fe922ccd9865d093cb53ac70a4d85bd6a2f4ca64cae3b969b9c378c4dad63"
    sha256 cellar: :any_skip_relocation, sonoma:        "5289843c595cdf865e48bec579de237e1c08985ef8e30f06f12958e2e9531373"
    sha256                               arm64_linux:   "e0cfe6b77c813c726c11b42b6ac79ceb488f85c6910bd089f2deef4d816b916a"
    sha256                               x86_64_linux:  "ba7b23461b7951632699ff82e3295fe3b78276a728113f903b68b0290d1287ae"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.8.6.tar.gz"
    sha256 "da9eb433bc383c26acf47ec27f8e4ee6df8aa20cbd9cc90beaad6c2762ccbe8c"

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
