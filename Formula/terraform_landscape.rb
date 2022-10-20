class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/v0.3.4.tar.gz"
  sha256 "9e9b8e00aacf821fd07c9e3194e1e9f5824032dad4b12995649bcd9c59731ee1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6bddaa5d9648cc10f137bbdbf0e05d10239f49dde7c6fed01c887e52b0ba5725"
    sha256 cellar: :any_skip_relocation, big_sur:       "1bcd487a444cb78b3afdd394442ae24c4c1fa1fad393d76451a64c33b539b10f"
    sha256 cellar: :any_skip_relocation, catalina:      "af2918fc17765a6cbabaa0aae039afe3c5aa00821581570901a89e0edc850285"
    sha256 cellar: :any_skip_relocation, mojave:        "5afa045cd1b2974f6247f3a31ae1e0141e5e9091b4c81a2a4660d5d06c90ca20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4df8fb485f198c90e494bbc1b19d5c18f48c436e505f85de202cd1cc46f0c316"
    sha256 cellar: :any_skip_relocation, all:           "4df8fb485f198c90e494bbc1b19d5c18f48c436e505f85de202cd1cc46f0c316"
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
