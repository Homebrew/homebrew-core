class Rubocop < Formula
  desc "Ruby static code analyzer and formatter, based on the community Ruby style guide"
  homepage "https://docs.rubocop.org"
  url "https://github.com/rubocop/rubocop/archive/refs/tags/v1.93.0.tar.gz"
  sha256 "5dd0af9f9540e536dc4c35a87481b573d414b8c9b3491aec1c30f22c3c3f00cd"
  license "MIT"
  head "https://github.com/rubocop/rubocop.git", branch: "master"

  bottle do
    manifest_sha256 "d7bf7c725faa3e7b19e9f87143354bc41d9e53f4984718e95fbf91a6a85c2328"
    sha256 cellar: :any, arm64_golden_gate: "58192266dfd8e5fce07fdee54280ab9606d657486b567f186438f5b85a2659f4"
    sha256 cellar: :any, arm64_tahoe:       "57d88a6e3ffc9aa98b50d1851aefef73bc18941bf0256f0a9ee154d5e61541cf"
    sha256 cellar: :any, arm64_sequoia:     "5229406fe2b067484b0d556b7d699dc7271181de859199a0781ac6fbfc50b33e"
    sha256 cellar: :any, arm64_linux:       "25a731075f80fa74bb7c4903105008ad877844bf1f869ef12e6061cc1a2d7c9b"
    sha256 cellar: :any, x86_64_linux:      "ca17a00f5033f4148215bbb8644f74726c45fddbc3079aed5576fa63f3c9684d"
  end

  depends_on "ruby"

  # List with `gem install --explain rubocop -v #{version}`
  resource "ast" do
    url "https://rubygems.org/downloads/ast-2.4.3.gem"
    sha256 "954615157c1d6a382bc27d690d973195e79db7f55e9765ac7c481c60bdb4d383"
  end

  resource "json" do
    url "https://rubygems.org/downloads/json-2.21.2.gem"
    sha256 "1f1d3b7cf2b3ba1a69beca0bb6db13d5438b80bff3cd54cdaaa620b9b07c1c6a"
  end

  resource "language_server-protocol" do
    url "https://rubygems.org/downloads/language_server-protocol-3.17.0.6.gem"
    sha256 "5ef2c0c138f8267e1bc631d3328347d354f96724b0af22f2c79516120443b7f0"
  end

  resource "lint_roller" do
    url "https://rubygems.org/downloads/lint_roller-1.1.0.gem"
    sha256 "2c0c845b632a7d172cb849cc90c1bce937a28c5c8ccccb50dfd46a485003cc87"
  end

  resource "parallel" do
    url "https://rubygems.org/downloads/parallel-2.3.0.gem"
    sha256 "f75a3e904101ce6a1ccb6b8dc800cbafd42166d83330192438dcf29395167a6f"
  end

  resource "parser" do
    url "https://rubygems.org/downloads/parser-3.3.14.0.gem"
    sha256 "62f8f76af7b919425ee2d811880e9dcb8011ab40bfd59970dfb583141697e58f"
  end

  resource "prism" do
    url "https://rubygems.org/downloads/prism-2.1.0.gem"
    sha256 "1c0a7c6dea0e93183390fb123f007564dbe663198e2f86ad87204151147601f3"
  end

  resource "racc" do
    url "https://rubygems.org/downloads/racc-1.8.1.gem"
    sha256 "4a7f6929691dbec8b5209a0b373bc2614882b55fc5d2e447a21aaa691303d62f"
  end

  resource "rainbow" do
    url "https://rubygems.org/downloads/rainbow-3.1.1.gem"
    sha256 "039491aa3a89f42efa1d6dec2fc4e62ede96eb6acd95e52f1ad581182b79bc6a"
  end

  resource "regexp_parser" do
    url "https://rubygems.org/downloads/regexp_parser-2.13.4.gem"
    sha256 "1d0547814f57e6f00946957bd0ca201bc42f42cfb08eee89df60998aedcd8a3b"
  end

  resource "rubocop-ast" do
    url "https://rubygems.org/downloads/rubocop-ast-1.54.0.gem"
    sha256 "11f7cadec54e593e905b1bb78f2b28bdd4b8e13b34cb82fe49c876e3dd5008c1"
  end

  resource "ruby-progressbar" do
    url "https://rubygems.org/downloads/ruby-progressbar-1.13.0.gem"
    sha256 "80fc9c47a9b640d6834e0dc7b3c94c9df37f08cb072b7761e4a71e22cff29b33"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/downloads/unicode-display_width-2.6.0.gem"
    sha256 "12279874bba6d5e4d2728cef814b19197dbb10d7a7837a869bab65da943b7f5a"
  end

  deny_network_access!

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies", "--no-document"
    end
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "--no-document", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV.fetch("GEM_HOME"))
  end

  test do
    (testpath/"test.rb").write("answer=42\n")
    output = shell_output("#{bin}/rubocop --only Layout/SpaceAroundOperators test.rb", 1)
    assert_match "Layout/SpaceAroundOperators", output
  end
end
