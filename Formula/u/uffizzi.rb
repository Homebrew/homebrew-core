class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "bdeb15e30760c5e12d404b616dd92d1efa6cbbf6b73ae3c6a0dea8abcabafb6b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "beaa44595b887aa5a198a6bc4373b78863015278df99b809b4850bf577296a8e"
    sha256 cellar: :any,                 arm64_ventura:  "a438d45c0f1300242c00034b46b8f12a3c7f68a441a20c6cdf0d3c51ba277727"
    sha256 cellar: :any,                 arm64_monterey: "be610445936160783388b4bc95d0e149360e88450e39c3d5c6616710e2560f9e"
    sha256 cellar: :any,                 sonoma:         "4aca3e986d4b8b7daa9aac01f11a96b4cd8d17d20c07a74f61342d0f479a5227"
    sha256 cellar: :any,                 ventura:        "9c09196d7ebc9cc1bbefc3d6df535eec6dcb3ad15ac702dd3427730084ff280a"
    sha256 cellar: :any,                 monterey:       "602264d64708895a722daf1b0b8001932faf5d4b3b26b02101c6fbccc3354581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19b054ecc1d290036513e41d6592cddfab2bcd4d102c343f604b9c1c28f2513b"
  end

  depends_on "ruby"
  depends_on "skaffold"

  # Runtime dependencies of uffizzi
  # List with `gem install --explain uffizzi-cli`
  resource "tty-cursor" do
    url "https://rubygems.org/gems/tty-cursor-0.7.1.gem"
    sha256 "79534185e6a777888d88628b14b6a1fdf5154a603f285f80b1753e1908e0bf48"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "wisper" do
    url "https://rubygems.org/gems/wisper-2.0.1.gem"
    sha256 "ce17bc5c3a166f241a2e6613848b025c8146fce2defba505920c1d1f3f88fae6"
  end

  resource "tty-screen" do
    url "https://rubygems.org/gems/tty-screen-0.8.1.gem"
    sha256 "6508657c38f32bdca64880abe201ce237d80c94146e1f9b911cba3c7823659a2"
  end

  resource "tty-reader" do
    url "https://rubygems.org/gems/tty-reader-0.9.0.gem"
    sha256 "c62972c985c0b1566f0e56743b6a7882f979d3dc32ff491ed490a076f899c2b1"
  end

  resource "tty-color" do
    url "https://rubygems.org/gems/tty-color-0.6.0.gem"
    sha256 "6f9c37ca3a4e2367fb2e6d09722762647d6f455c111f05b59f35730eeb24332a"
  end

  resource "pastel" do
    url "https://rubygems.org/gems/pastel-0.8.0.gem"
    sha256 "481da9fb7d2f6e6b1a08faf11fa10363172dc40fd47848f096ae21209f805a75"
  end

  resource "tty-prompt" do
    url "https://rubygems.org/gems/tty-prompt-0.23.1.gem"
    sha256 "fcdbce905238993f27eecfdf67597a636bc839d92192f6a0eef22b8166449ec8"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.3.0.gem"
    sha256 "1adc7f9e5b3655a68c71393fee8bd0ad088d14ee8e83a0b73726f23cbb3ca7c3"
  end

  resource "concurrent-ruby" do
    url "https://rubygems.org/gems/concurrent-ruby-1.2.2.gem"
    sha256 "3879119b8b75e3b62616acc256c64a134d0b0a7a9a3fcba5a233025bcde22c4f"
  end

  resource "sentry-ruby" do
    url "https://rubygems.org/gems/sentry-ruby-5.14.0.gem"
    sha256 "0940fb8b5de834aa735e29ae674332be4a5a62c303669c4d98a817ae6adac280"
  end

  resource "securerandom" do
    url "https://rubygems.org/gems/securerandom-0.2.2.gem"
    sha256 "5fcb3b8aa050bac5de93a5e22b69483856f70d43affeb883bce0c58d71360131"
  end

  resource "minitar" do
    url "https://rubygems.org/gems/minitar-0.9.gem"
    sha256 "23c0bebead35dbfe9e24088dc436c8a233d03f51d365a686b9a11dd30dc2d588"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-5.0.4.gem"
    sha256 "35cd648e0d21d06b8dce9331d19619538d1d898ba6d56a6f2258409d2526d1ae"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.8.5.gem"
    sha256 "63f0fbcde42edf116d6da98a9437f19dd1692152f1efa3fcc4741e443c772117"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.5.2.gem"
    sha256 "8aa0441655aec5514008e1d04892c2de3ba57bd337afb984568da091121a241b"
  end

  resource "i18n" do
    url "https://rubygems.org/gems/i18n-1.14.1.gem"
    sha256 "9d03698903547c060928e70a9bc8b6b87fda674453cda918fc7ab80235ae4a61"
  end

  resource "faker" do
    url "https://rubygems.org/gems/faker-3.2.2.gem"
    sha256 "1eca58d4611fcc07e1b2b89c6e394a9d2ff780e943752f5ea2dd60e0cc3c84c5"
  end

  resource "awesome_print" do
    url "https://rubygems.org/gems/awesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "tzinfo" do
    url "https://rubygems.org/gems/tzinfo-2.0.6.gem"
    sha256 "8daf828cc77bcf7d63b0e3bdb6caa47e2272dcfaf4fbfe46f8c3a9df087a829b"
  end

  resource "mutex_m" do
    url "https://rubygems.org/gems/mutex_m-0.1.2.gem"
    sha256 "0a9bc5ebe3495e3fc39b1c56292792c1f793b3926fad050cd17b1272cfb57dde"
  end

  resource "minitest" do
    url "https://rubygems.org/gems/minitest-5.16.3.gem"
    sha256 "60f81ad96ca5518e1457bd29eb826db60f86fbbdf8c05eac63b4824ef1f52614"
  end

  resource "ruby2_keywords" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "drb" do
    url "https://rubygems.org/gems/drb-2.1.1.gem"
    sha256 "6b8f481d9a9a7528c41d4f66484a4a73d2204f095da8ab141b5ea0aa22162c41"
  end

  resource "connection_pool" do
    url "https://rubygems.org/gems/connection_pool-2.4.1.gem"
    sha256 "0f40cf997091f1f04ff66da67eabd61a9fe0d4928b9a3645228532512fab62f4"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.3.gem"
    sha256 "3b4c2149f4fee5f42d7ef79cd0c24aafd32bd9888f84f0ecea5672946d646f58"
  end

  resource "base64" do
    url "https://rubygems.org/gems/base64-0.1.1.gem"
    sha256 "0c75d351a429b5176a476cd8a3740cff3277d2bac26a50b5c7456c266e9acd33"
  end

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-7.1.2.gem"
    sha256 "5bd81ef71524a14725ecb6c3b07bfc00ae0ccc77dd611190bd93bd9f92abd0d0"
  end

  resource "uffizzi-cli" do
    url "https://rubygems.org/gems/uffizzi-cli-2.3.4.gem"
    sha256 "b0d081dc37cb08eafbc18dee3056eaab099401d74335a8d0a4d0e06a057e9a70"
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
