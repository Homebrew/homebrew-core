class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "f93357b61135788a0b76d0dc6cf10cd8235ae58fcc1b53b953138adb94d48b9b"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8348ee639d8db9e32f1fcc0b5961f5a555793b09ba2dff036701596854494df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c915911535e57213564b68e7d7674bc825ceebc745f89c4e7a934ab875f7c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "009b0723b4d33218f69a81dc3f2644e04e8a907bed3f70cdfe0764e69559fda8"
    sha256 cellar: :any_skip_relocation, ventura:        "3799c024ac8502c875a4f7592a5a05a3bd8dbbf94c0fd41212d388c3c7b10506"
    sha256 cellar: :any_skip_relocation, monterey:       "84d05a18063d49aadfdad4dca9bea3059af131dabc0d1288eeab04399dae1b73"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2fd4c29c83b951de22b19b1b7bc9eea3d1c84a7b52157a5b14c84ab01e706c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68ea2753a333e18da4cf2506524db21298a96388960bef62ed387d8470ebd7ef"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
