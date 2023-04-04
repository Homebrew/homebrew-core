require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.32.0.tgz"
  sha256 "099a3ae7e5261f15069e785eb5a9e3bafd575c92c1064d796591ed20c1cc7b05"
  license "AGPL-3.0-only"

  bottle do
    sha256                               arm64_ventura:  "6d83defd222f8187ee0fa9c1447853cc4ea02188cc88d320597c18d28a98327d"
    sha256                               arm64_monterey: "374c714d5f12a7cc290955b9011f81c37da29b15df14acd4da32ce036c11ebd4"
    sha256                               arm64_big_sur:  "648a3d64d4048d9d1edd7dec561fa67e1bbe3776fc99f70b799603496a30d557"
    sha256 cellar: :any_skip_relocation, ventura:        "bf570bc125c8ece4630d1a60ddc65824357da6efe0398622b62c00376e343e39"
    sha256 cellar: :any_skip_relocation, monterey:       "7451e293ad4a1b4ad27116213bb2fe009956947b46d563df0bd0920faa5e5745"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f25c0c11cc0c63ad24c22551a6209ef910adf3e44f4a3c97375b70287b0ef36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed633c35a996a07be0daf921ae5ffb0239f3ffda44a03f70ad691c6d86349993"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
