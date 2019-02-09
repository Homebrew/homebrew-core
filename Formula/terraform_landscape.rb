class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/v0.3.1.tar.gz"
  sha256 "0bdfa852240214d413e510437abb9a3f58ac7bc04262dc2ff4e9efaa1945f89d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c064b916a316445484ee9d87adb0b63015560c437182c19c053128e98c3b2edc" => :mojave
    sha256 "115f67f424ce6254f2b2dfe26d024dc176855b72c1856b7690045b6c01bb30db" => :high_sierra
    sha256 "b2a9e278063dd2018c0d552927c0341870ab6260172771be8e3c48a717fd3158" => :sierra
  end

  depends_on "ruby"

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "commander" do
    url "https://rubygems.org/gems/commander-4.4.7.gem"
    sha256 "8fc35d22ba7a386adecb728e68908e98b6a076340aaec6c654583a93ca9faadf"
  end

  resource "diffy" do
    url "https://rubygems.org/gems/diffy-3.3.0.gem"
    sha256 "909af322005817dfd848afb85ba5a30c65c38299b288349ac8c1744607391d62"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-2.0.1.gem"
    sha256 "ec0bab47f397b32d09b599629cf32f4fc922470a09bef602ef5e492127bb263f"
  end

  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.10.gem"
    sha256 "67df9f52c5fdeb7b2b8ce42156f9d019c1c4eb643481a68149ff6c0b65bc613c"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document",
                    "--ignore-dependencies", "--install-dir", libexec
    end
    system "gem", "build", "terraform_landscape.gemspec"
    system "gem", "install", "--ignore-dependencies", "terraform_landscape-#{version}.gem"
    bin.install libexec/"bin/landscape"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
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
