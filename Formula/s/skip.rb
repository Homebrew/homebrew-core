class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.9.16.tar.gz"
  sha256 "c8ceedb6b93ffee714c2162b84cee81f0569faf0a41af62d3a42e9e3d7391cc1"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "95d6042a24039d20889cd33f479b7839fff311f23de7a43002f3de26144c515c"
    sha256 arm64_tahoe:       "6bd84ca1dd901cd032f93fc657848026e5aa8fb4aae350ebd5b077ac5d8f7a6e"
    sha256 arm64_sequoia:     "6dad772ea7c6861d57ed33cf8bd423a22f9d3b37caf3fc236538d0ea8ca8a132"
    sha256 arm64_linux:       "0a27ea3ab729a6978cd8a7b7c4fbe2d1a222359ec1067a1d889c3486351bb7b0"
    sha256 x86_64_linux:      "d1086b82e60a653824e7fe8366251c5826ce0faf9c6bc26b8aa6d04ed66f4bbe"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.9.16.tar.gz"
    sha256 "e855d7dd331d8ab08099b822d59f9cc6e574015ff744bb1c2112f4de1afaeb07"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    # FIXME: need to update brew as Swift 6.4.0+ doesn't use ld shim anymore
    if OS.linux?
      args = ENV["HOMEBREW_LIBRARY_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-L#{it}"] } +
             ENV["HOMEBREW_RPATH_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-rpath", "-Xlinker", it] }
    end

    system "swift", "build", "--product", "SkipRunner", *args, *std_swift_args
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
