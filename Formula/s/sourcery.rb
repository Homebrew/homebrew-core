class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.3.0.tar.gz"
  sha256 "097aa2628cfbba2f8c2d412c57f7179c96082ab034fc6b2a2e905a0d344269e6"
  license "MIT"
  revision 1
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8338cca5f963c8d7d45267a13aca1f01ef594783da95a96d96ca0dd84ecdb8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a12451e3bc1920d070923c9a9472d2202dc04d41f0bace58928eb6445ae6a79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57c585fe096b6dff6c82cb975f5bc654d162759c0d3b4c74d56a5b2c669ee008"
    sha256 cellar: :any_skip_relocation, sonoma:        "786e56e3881666c1ea880ead6b070fd6cf4b300634c3dbdf2a1f43e7e16bdbc2"
    sha256                               arm64_linux:   "db8d5bc1475a737448111a97790c2a4ed72b0144048fd5b5c28ed6b533fa5616"
    sha256                               x86_64_linux:  "017c7fc58e6665e6cd19bf0fc37af3dd77c2bc93d991d329b69814ff6b4f20f9"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    # Build script is unfortunately not customisable.
    # We want static stdlib on Linux as the stdlib is not ABI stable there
    # and use our ld shim to help find Homebrew libraries
    inreplace "Rakefile", "--disable-sandbox", "--static-swift-stdlib -Xswiftc -use-ld=ld" if OS.linux?

    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
