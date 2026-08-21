class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.9.7.tar.gz"
  sha256 "6bdd1300dc0d81f06327053991d1fbe7cf694f420b9b3245da0e8200b75d8b20"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "d8e978f8884b17e0dab748978bb7f037d2e9370d66a282c231270377b17c810e"
    sha256                               arm64_sequoia: "1b14040dc6fa39c9816defe29ce1f265e295835774e195eece69aaf88c517263"
    sha256                               arm64_sonoma:  "197083ee7e51ed7b83cd8202fd4308442f4a6d26a3679c85d45c5b519e97622d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96707bfd3aec940265a7066682d63e3f313b46f412544d976841c5c2237858c"
    sha256                               arm64_linux:   "f3c188b7df244ef4742b8b18b0f8067b46158435d71cf4f73b8ac6cea234fecc"
    sha256                               x86_64_linux:  "b36440f62d27a49dfb59ca472f699ddf0449b3a43e35e7430fa9be36f3a36df7"
  end

  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://github.com/skiptools/skip/archive/refs/tags/1.9.7.tar.gz"
    sha256 "9e1db7588cc421b2ce68730eb7140ca3d2d5147e97879ec8544911f9b7516118"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    system "swift", "build", "--product", "SkipRunner", *std_swift_args
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
