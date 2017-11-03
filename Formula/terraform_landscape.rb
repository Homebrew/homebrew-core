class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/v0.1.16.tar.gz"
  sha256 "93556adb4901a076d5900e7a6205375813cb332b4a59373da55fb3e45361bfb7"

  depends_on :ruby => "2.0"

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "commander" do
    url "https://rubygems.org/gems/commander-4.4.3.gem"
    sha256 "aedf4af6fdf8f05489001bcd70af87d83afec6896a3a2dfd9b49ec02bc391d07"
  end

  resource "diffy" do
    url "https://rubygems.org/gems/diffy-3.2.0.gem"
    sha256 "8124e5b1d9c0086994b6484d26f37476b79253309ccaebea201247a67eb2b604"
  end

  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.8.gem"
    sha256 "385cbbf3827a0a8559e4c79db0f0f88993dca5e8ce46cf08f1baccb61ac6a3cf"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document",
                    "--install-dir", libexec
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
