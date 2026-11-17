class Rubocop < Formula
  desc "Ruby static code analyzer and formatter, based on the community Ruby style guide"
  homepage "https://docs.rubocop.org"
  url "https://github.com/rubocop/rubocop/archive/refs/tags/v1.92.3.tar.gz"
  sha256 "52ecb61f8ff367db41eda22f366ae9d13bc14ba8bd5ffa94f8d9cf11d5ab5c97"
  license "MIT"
  head "https://github.com/rubocop/rubocop.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e774426c6cf320067f92a460277a01925a4838ab7e410279bf66e5e7c757fe97"
    sha256 cellar: :any, arm64_tahoe:       "66b55b9ae1fbe363786ca17854bf1981810a39b5499f7ed90d6bc78f96d38551"
    sha256 cellar: :any, arm64_sequoia:     "317ec3671dc6f9aab500545b04cffb34250766ade80907c39ce332494e2c0f76"
    sha256 cellar: :any, arm64_linux:       "e266f8272de6d8d2999fd0f30a32cd6c4577e277f13fc8b69e52cc7c8048c8b4"
    sha256 cellar: :any, x86_64_linux:      "389d9d0929faf64fccc8e1d3d3fdc8d0deeb5388dcf0589a7fd1f191f3418a4f"
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
    url "https://rubygems.org/downloads/parser-3.3.13.0.gem"
    sha256 "e02f9b63c2fe05b0c68f692ba4df89b3cb113b663964f75d988fbebfd6c3deca"
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
    url "https://rubygems.org/downloads/regexp_parser-2.13.3.gem"
    sha256 "c9833eb62afc9706ebdc61b2b41226c0ae3b45a2783f80174cffcf126453db27"
  end

  resource "rubocop-ast" do
    url "https://rubygems.org/downloads/rubocop-ast-1.51.0.gem"
    sha256 "0ec311e36b191b3872d909078a35274e962ae97dbce64be6812d145ca59acfcb"
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
