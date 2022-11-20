class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "5132d1e1f4f5eb3c6e8b2254e7c75c638d35023992869185704e3ead2c99e2ff"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5b5e017b2b69a5f3fe1e1408c96011de96cdc353c3a0b3fd57593866aa0ead5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5381ed1d607fac95b09921ceb1d2d2921583d4a3c16c0515ec7efbb415908570"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7dfed69d1ba19464466a5d32d6fed06738c56de36d43eaf4ff1a84e8e0494fd"
    sha256 cellar: :any_skip_relocation, monterey:       "b8182aa3a2a0eb334ffbe3da9ab66ffcb396d84544c13bdad2015d201d5f797d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c3a33a9674a7fb90eada11fe4e28477f8c2a355edfe8b99982cde38cc27d7eb"
    sha256 cellar: :any_skip_relocation, catalina:       "087aed05b7276f3fe0a23347927df615c1e97837204d849094c1c67f937edf59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e43bfc3e3dac7c6b520987bf3882ca7d15a5107a12124dcd95ab85f3c95bc9"
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
