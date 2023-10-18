class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "c2ea0bda27b9c279044dd1dff9c1db858f6def6336214ce0b3b8f3d11b313b2d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7ec2eee997d073a63285fc83891be9313b82dfb0001344ab6131ab885ff529f5"
    sha256 cellar: :any,                 arm64_ventura:  "a4ef781937240335fbca5c23d979992057b17347d701e1f3766a1d8a6a7572d5"
    sha256 cellar: :any,                 arm64_monterey: "cfbfe84b5621b6291b9ef7359906c0d2dd088860272dd9201ddf4f609cf062c0"
    sha256 cellar: :any,                 sonoma:         "154b0201060feefd2e7f7c3b81c51660f83f47d81ce8d93a328538e63ef516c7"
    sha256 cellar: :any,                 ventura:        "9ceb009ea4519ffbd05eb437bc7a20f9ae27968f67809035c1b3ebf0806df89f"
    sha256 cellar: :any,                 monterey:       "79a67670106c548cc8142edd3d92ea673bb96d0a0160761eb229d599dcbf1e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6dde559a497aed13e3d701d3973bff93ba1b635c92d6a80902dcf111233e667"
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
    url "https://rubygems.org/gems/uffizzi-cli-2.1.4.gem"
    sha256 "51ccc3f417ccb47ab7b035286830fa7079a007578f3f3c50994ff613cd6c08f0"
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
