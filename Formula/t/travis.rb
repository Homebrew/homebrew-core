class Travis < Formula
  desc "Command-line client for Travis CI"
  homepage "https://github.com/travis-ci/travis.rb/"
  url "https://github.com/travis-ci/travis.rb/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "57fa5a3adc65e36f6fe7f4de673d7e44932c1fb6373081fc59787fa8a1f9b0d2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2f65f4d4c87f7e495738447c4611e3185daae3843c43598c7a6579813b031b23"
    sha256 cellar: :any,                 arm64_ventura:  "97f5a55d76e5705fbd115b1245e3d3298ac5aa264ff6c11fe8d95f4edd246624"
    sha256 cellar: :any,                 arm64_monterey: "806951224f44ededcaa6133aa5a327f25b23fcd12eca6680f686070a1c0792dc"
    sha256 cellar: :any,                 sonoma:         "525ce73c6bf2b3eab4656b1698acebef0b8b5478d987d898e9b4116585dbbb34"
    sha256 cellar: :any,                 ventura:        "6268c5e6afda03121560a8fe7070161a51345a116b3edb2f2c8d1c576656bf99"
    sha256 cellar: :any,                 monterey:       "94175386e959e0bf8aaa1400dca6d198059334541a04b58d72a6dff465f2afac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b18c8115c15be6aecd5784e38cc18676fe81a6dc095ea51bf5c5fea8b3ad8648"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"

  resource "websocket" do
    url "https://rubygems.org/gems/websocket-1.2.10.gem"
    sha256 "2cc1a4a79b6e63637b326b4273e46adcddf7871caa5dc5711f2ca4061a629fa8"
  end

  resource "json" do
    url "https://rubygems.org/gems/json-2.7.1.gem"
    sha256 "187ea312fb58420ff0c40f40af1862651d4295c8675267c6a1c353f1a0ac3265"
  end

  resource "pusher-client" do
    url "https://rubygems.org/gems/pusher-client-0.6.2.gem"
    sha256 "c405c931090e126c056d99f6b69a01b1bcb6cbfdde02389c93e7d547c6efd5a3"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-5.0.4.gem"
    sha256 "35cd648e0d21d06b8dce9331d19619538d1d898ba6d56a6f2258409d2526d1ae"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.8.6.gem"
    sha256 "798f6af3556641a7619bad1dce04cdb6eb44b0216a991b0396ea7339276f2b47"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.5.2.gem"
    sha256 "8aa0441655aec5514008e1d04892c2de3ba57bd337afb984568da091121a241b"
  end

  resource "json_pure" do
    url "https://rubygems.org/gems/json_pure-2.6.3.gem"
    sha256 "c39185aa41c04a1933b8d66d1294224743262ee6881adc7b5a488ab2ae19c74e"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-2.1.0.gem"
    sha256 "d63d7f472f8ffaa143725161ae6fb06895b5cb7527e0b4dac5ad1e4902c80cb9"
  end

  resource "ruby2_keywords" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "faraday-net_http" do
    url "https://rubygems.org/gems/faraday-net_http-3.0.2.gem"
    sha256 "6882929abed8094e1ee30344a3369e856fe34530044630d1f652bf70ebd87e8d"
  end

  resource "base64" do
    url "https://rubygems.org/gems/base64-0.2.0.gem"
    sha256 "0f25e9b21a02a0cc0cea8ef92b2041035d39350946e8789c562b2d1a3da01507"
  end

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-2.7.12.gem"
    sha256 "ed38dcd396d2defcf8a536bbf7ef45e6385392ab815fe087df46777be3a781a7"
  end

  resource "faraday-rack" do
    url "https://rubygems.org/gems/faraday-rack-2.0.0.gem"
    sha256 "41759651c9e8baba520c21f807a8787dbb8480c2dbe64569264346ffad6b0461"
  end

  def install
    ENV["GEM_HOME"] = libexec
    # gem issue on Mojave
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :mojave

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "travis.gemspec"
    system "gem", "install", "--ignore-dependencies", "travis-#{version}.gem"
    bin.install libexec/"bin/travis"
    (libexec/"gems/travis-#{version}/assets/notifications/Travis CI.app").rmtree
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    output = shell_output(bin/"travis whoami 2>&1 --pro", 1)
    assert_equal "not logged in, please run travis login --pro", output

    output = shell_output("#{bin}/travis init 2>&1", 1)
    assert_equal "Can't figure out GitHub repo name", output
  end
end
