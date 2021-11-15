require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.18.tgz"
  sha256 "7bc917ccbb9aa33773b8915400c4c7fbae375a346dba6613e5b0eaae7cad6fb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26ee350bc93b45aca15ea4ddfecad513b4fe07f2ca143ba215241387572a5afb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54ab4e9703e79db7145005c5f4e8a2b09001bc6a6a4c0ca0e074d20cb71b252a"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa377f0d9fc242605e26308f4ddd90b317703bad6d48bd25f1175de5d1ee7ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "6768008e7ce0700279019566b2c5fab0a906823696b225e54b883bc30d4b52b7"
    sha256 cellar: :any_skip_relocation, catalina:       "6768008e7ce0700279019566b2c5fab0a906823696b225e54b883bc30d4b52b7"
    sha256 cellar: :any_skip_relocation, mojave:         "6768008e7ce0700279019566b2c5fab0a906823696b225e54b883bc30d4b52b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fed1c88fef55106397629b390d0c369cb1b7f179922b9b938e9e5b9a02f0698"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}"
    end
    sleep 8

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end
