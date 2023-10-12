class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "65a174fcf978675d594ce088cd945d6d99cadbad77f65f948d2156de56c3d943"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3fed4b30383802eb053304ae47f4c4bf0c76b07c72335e53aa3280ebf0455dfd"
    sha256 cellar: :any,                 arm64_ventura:  "aefd52da7526189015a23c3f4781137e39516c3df118ec59f9b47ac48b31a8ba"
    sha256 cellar: :any,                 arm64_monterey: "aaf7f5edbc0c1faaa0e75883cdc31f26bdde39a8c27615f265579dce879241b7"
    sha256 cellar: :any,                 sonoma:         "7d8d9baf206f6ea9713939ef65b83d6e131c9eb78fcee3cfa085b81e18b8993c"
    sha256 cellar: :any,                 ventura:        "8a43987c0692ceb0c090003452248558e8fbf48983d111c9974959e664229cca"
    sha256 cellar: :any,                 monterey:       "2e9d291ad6e7f8fcf3d42326d36a29754d4d013b512ec67d8b6861d5182b319d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "084b128edde35adc234edb6d7b73ea586cbf983bfb6cf655e7e00aa96e173203"
  end

  depends_on "ruby@3.0"

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-6.1.4.1.gem"
    sha256 "44b781877c2189aa15ca5451e2d310dcedfd16c01df1106f68a91b82990cfda5"
  end

  resource "awesome_print" do
    url "https://rubygems.org/gems/awesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "faker" do
    url "https://rubygems.org/gems/faker-3.2.1.gem"
    sha256 "d6b201b520213f6d985ac9f9f810154397a146ca22c1d3ff0a6504ef37c5517b"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.5.2.gem"
    sha256 "8aa0441655aec5514008e1d04892c2de3ba57bd337afb984568da091121a241b"
  end

  resource "minitar" do
    url "https://rubygems.org/gems/minitar-0.9.gem"
    sha256 "23c0bebead35dbfe9e24088dc436c8a233d03f51d365a686b9a11dd30dc2d588"
  end

  resource "securerandom" do
    url "https://rubygems.org/gems/securerandom-0.2.2.gem"
    sha256 "5fcb3b8aa050bac5de93a5e22b69483856f70d43affeb883bce0c58d71360131"
  end

  resource "sentry-ruby" do
    url "https://rubygems.org/gems/sentry-ruby-5.11.0.gem"
    sha256 "27f603638d75d28b974def362792f442ae39e3e1c1496427910f9a0f434f3a71"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.2.2.gem"
    sha256 "2f93c652828cba9fcf4f65f5dc8c306f1a7317e05aad5835a13740122c17f24c"
  end

  resource "tty-prompt" do
    url "https://rubygems.org/gems/tty-prompt-0.23.1.gem"
    sha256 "fcdbce905238993f27eecfdf67597a636bc839d92192f6a0eef22b8166449ec8"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "uffizzi-cli" do
    url "https://rubygems.org/gems/uffizzi-cli-2.1.2.gem"
    sha256 "6e976f91a61613527b89dbf1dcd92652646cf332aca96436506a012cd449e2a9"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document", "--install-dir", libexec
    end

    bin.install Dir["#{libexec}/bin/*"]

    bin.env_script_all_files(libexec, GEM_HOME: ENV["GEM_HOME"], GEM_PATH: ENV["GEM_PATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uffizzi version")
    server_url = "https://example.com"
    system bin/"uffizzi config set server #{server_url}"
    assert_match server_url, shell_output("#{bin}/uffizzi config get-value server")
  end
end
