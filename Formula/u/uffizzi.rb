class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.0.37.tar.gz"
  sha256 "522177bbf2962f711bcc321502fc1e1773ff148a9e763ddb7f747b1af812de8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50ca0e2849b13b877619970dd18e1c806584b771cdb10f1e981a2692fa3325c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56e0b5801b372f5aced9011e6d544d215f71d2e3f5372c55ea1c04ecb7d2813e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56e0b5801b372f5aced9011e6d544d215f71d2e3f5372c55ea1c04ecb7d2813e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56e0b5801b372f5aced9011e6d544d215f71d2e3f5372c55ea1c04ecb7d2813e"
    sha256 cellar: :any_skip_relocation, sonoma:         "965392d5c5b747afc9a95f6ca47a8b4f2c2e31f1e71173f5eb03cce8d17c8905"
    sha256 cellar: :any_skip_relocation, ventura:        "e750853aa0a9a3247b12909405171a0c37643465a261217c81bc32dda3bb478a"
    sha256 cellar: :any_skip_relocation, monterey:       "e750853aa0a9a3247b12909405171a0c37643465a261217c81bc32dda3bb478a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e750853aa0a9a3247b12909405171a0c37643465a261217c81bc32dda3bb478a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e0b5801b372f5aced9011e6d544d215f71d2e3f5372c55ea1c04ecb7d2813e"
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
    url "https://rubygems.org/gems/uffizzi-cli-2.0.37.gem"
    sha256 "2db5a047ce1928dd444c13b2c7a6ccdc38b125f519b7445da231996e8830ceaa"
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
