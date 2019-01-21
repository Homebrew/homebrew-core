require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere."
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.36.tgz"
  sha256 "3bb07b99e2616afd3059809768036eaefd92d1a62cfab9dc087b9405933ec7f4"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # this app launches a web server but does not provide any command-line to test;
    # so just run the version number display to make sure that works at least:
    system bin/"ungit", "--version"
  end
end
