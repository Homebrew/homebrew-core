class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skip/archive/refs/tags/1.9.21.tar.gz"
  sha256 "5b46923ed3144d0e5c0db07f6b243be32c323299eac709b4711da5b71d5669b5"
  license "Apache-2.0" => { with: "Swift-exception" }
  head "https://github.com/skiptools/skip.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "ddd711d533403b04ce5e3a6ba48ab555665c1a11934072113dc34872911a60c4"
    sha256 arm64_tahoe:       "868e36a59efa6da54bee51631bda3397cf432df9d6d065ac47e1410e45d3673c"
    sha256 arm64_sequoia:     "38baf84db4695685e75f0100961257571284eda4ef35fed613452280b1cf9ff8"
    sha256 arm64_linux:       "951b4daa59c02db1e6c552dbca078ae5967e377ae5908c6413e7225f76bcffdc"
    sha256 x86_64_linux:      "141055148963b68c2a06181ac52392862c901309fc42c38330c4fb18d432b59c"
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

  def install
    # FIXME: need to update brew as Swift 6.4.0+ doesn't use ld shim anymore
    if OS.linux?
      args = ENV["HOMEBREW_LIBRARY_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-L#{it}"] } +
             ENV["HOMEBREW_RPATH_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-rpath", "-Xlinker", it] }
    end

    system "swift", "build", "--package-path", "skipstone", "--product", "SkipRunner", *args, *std_swift_args
    bin.install "skipstone/.build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end
