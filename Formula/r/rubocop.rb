class Rubocop < Formula
  desc "Ruby static code analyzer and formatter, based on the community Ruby style guide"
  homepage "https://docs.rubocop.org"
  url "https://github.com/rubocop/rubocop/archive/refs/tags/v1.89.0.tar.gz"
  sha256 "d0dd2cc7cf9a934412a7c636d8fc1d51193eef1928f5faa36ebb2537911472f2"
  license "MIT"
  head "https://github.com/rubocop/rubocop.git", branch: "master"

  depends_on "ruby"

  # List with `gem install --explain rubocop -v #{version}`
  resource "ast" do
    url "https://rubygems.org/downloads/ast-2.4.3.gem"
    sha256 "954615157c1d6a382bc27d690d973195e79db7f55e9765ac7c481c60bdb4d383"
  end

  resource "json" do
    url "https://rubygems.org/downloads/json-2.18.0.gem"
    sha256 "b10506aee4183f5cf49e0efc48073d7b75843ce3782c68dbeb763351c08fd505"
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
    url "https://rubygems.org/downloads/parallel-2.1.0.gem"
    sha256 "b35258865c2e31134c5ecb708beaaf6772adf9d5efae28e93e99260877b09356"
  end

  resource "parser" do
    url "https://rubygems.org/downloads/parser-3.3.12.0.gem"
    sha256 "21a6d7f755d5a24dfbdc6e6b772e4e879a52e7631a88bc5a3a134606052c9828"
  end

  resource "prism" do
    url "https://rubygems.org/downloads/prism-1.8.1.gem"
    sha256 "b260c1844ee0c7ead9c938f7fd63b95888c87cc054dfb64043204eccff8116ac"
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
    url "https://rubygems.org/downloads/regexp_parser-2.12.0.gem"
    sha256 "35a916a1d63190ab5c9009457136ae5f3c0c7512d60291d0d1378ba18ce08ebb"
  end

  resource "rubocop-ast" do
    url "https://rubygems.org/downloads/rubocop-ast-1.50.0.gem"
    sha256 "b9ca88300da0803ee222ad20cdb30494c0a784eed06fdc35d254b06d662788db"
  end

  resource "ruby-progressbar" do
    url "https://rubygems.org/downloads/ruby-progressbar-1.13.0.gem"
    sha256 "80fc9c47a9b640d6834e0dc7b3c94c9df37f08cb072b7761e4a71e22cff29b33"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/downloads/unicode-display_width-3.2.0.gem"
    sha256 "0cdd96b5681a5949cdbc2c55e7b420facae74c4aaf9a9815eee1087cb1853c42"
  end

  resource "unicode-emoji" do
    url "https://rubygems.org/downloads/unicode-emoji-4.2.0.gem"
    sha256 "519e69150f75652e40bf736106cfbc8f0f73aa3fb6a65afe62fefa7f80b0f80f"
  end

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
