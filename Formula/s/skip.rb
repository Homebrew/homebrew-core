class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.9.11.tar.gz"
  sha256 "da5280142a7537ad4424e6b420128d01edc24a0be6e654b60f8f44f56ffb4a85"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "1d7afd74ad748fb317aa75eedbf63aa3a83f2bc11b33eb3c87ba0e3a8421f4b7"
    sha256 arm64_tahoe:       "4c75fe32d25c2846b381a60bbcc1290850a800876199ec6c7671678cfc7c5271"
    sha256 arm64_sequoia:     "6ee0ae35694b0b9960518cd8dfda3f793b3ba5ea1be03a610115f92978f503ed"
    sha256 arm64_linux:       "65c366f04615d89b827fd769b2ec9f261feac4b495c7b1940953e6a33d998a8b"
    sha256 x86_64_linux:      "01ee1aa34976e57f6951b98f4603ba66514ea471f415971506e907c0b4cfa490"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.9.11.tar.gz"
    sha256 "ac55fb432f02460df5acba18f3ad814be9d2cb970b38ad0917ff7ad010acd8c7"

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
