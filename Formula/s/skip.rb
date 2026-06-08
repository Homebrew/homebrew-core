class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.9.2.tar.gz"
  sha256 "0e5b29e698fa8bf35600e2effb275b67f1a5e635d33a41e7f76aa63de6646ea0"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "b90be65c7f90170b499092922a813439c04794935d7f604954b8ecc686a29b55"
    sha256                               arm64_sequoia: "d895a60eec6646c43b6257bb9ee799b4840e75de995613b2bd6c058da176036a"
    sha256                               arm64_sonoma:  "03a19a42efc43b0ae769db89a686225de675b9b43d6f36c81a5764d00170e94c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4edef18015ab372c43c6d63ff2a6c40a07cca4c091d8495cf3693b3d2356ca4"
    sha256                               arm64_linux:   "03e1aa82724bf322fc63fc559d9c417c41f4b45bcda9c875528d5ed8e69104ee"
    sha256                               x86_64_linux:  "b5aa39ee6933f504513ebeaeb4d63a6814275c1c812124268d833bad4e792d69"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.9.2.tar.gz"
    sha256 "29ed02b7054d781898f786aa9cb4ce1b509921704ee40b86b33352f7dca3b5cb"

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
