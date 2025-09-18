class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "9e9b8e00aacf821fd07c9e3194e1e9f5824032dad4b12995649bcd9c59731ee1"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "6e403181c8828200717e99f9c86505f294c787db63060d1a356b4d95bff92f62"
  end

  depends_on "ruby"

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "commander" do
    url "https://rubygems.org/gems/commander-4.5.2.gem"
    sha256 "2c0746b01be9cfbbbf929d154a9bae0a224954c98b8e2b2f35b51984a6258f8c"
  end

  resource "diffy" do
    url "https://rubygems.org/gems/diffy-3.4.0.gem"
    sha256 "340cc7e53db308b305a7c9eed37655d347a78b72422a2df60b9699ffee3c2f5b"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-2.0.3.gem"
    sha256 "2ddd5c127d4692721486f91737307236fe005352d12a4202e26c48614f719479"
  end

  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.11.gem"
    sha256 "102e13adf065fc916eae60b9539a76101902a56e4283c847468eaea9c2c72719"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
                    "--ignore-dependencies", "--install-dir", libexec
    end
    system "gem", "build", "terraform_landscape.gemspec"
    system "gem", "install", "--ignore-dependencies", "terraform_landscape-#{version}.gem"
    bin.install libexec/"bin/landscape"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}/landscape -v")
    assert_match "Terraform Landscape #{version}", output

    test_input = "+ some_resource_type.some_resource_name"
    colorized_expected_output = "\e[0;32;49m+ some_resource_type.some_resource_name\e[0m\n\n\n"

    output = shell_output("echo '#{test_input}' | #{bin}/landscape")
    assert_match colorized_expected_output, output
  end
end
