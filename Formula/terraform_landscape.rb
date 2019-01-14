class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/v0.2.2.tar.gz"
  sha256 "09eb14df6c5743478380e6b8eb618226773da0a0055fe4fcf955018b5c9fb668"

  bottle do
    sha256 "55d689c8224f57a30b2dba356eef0f1b7bbf1c7e353724b236138dc0f678406b" => :mojave
    sha256 "ea8e016b581df875a5f2591c47698c6f75a4afea329cd2ed996bb1b0dc59d3d6" => :high_sierra
    sha256 "25ddfefd03e21886b042060b9bf5a9060ba2ab0565ae9580a3b492323d97403b" => :sierra
  end

  depends_on "ruby" if MacOS.version <= :mountain_lion

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "commander" do
    url "https://rubygems.org/gems/commander-4.4.7.gem"
    sha256 "8fc35d22ba7a386adecb728e68908e98b6a076340aaec6c654583a93ca9faadf"
  end

  resource "diffy" do
    url "https://rubygems.org/gems/diffy-3.2.1.gem"
    sha256 "4ffe1a7b01c958053407f9a8e6492c3e8c11b59db0ab5c3ae44f056067ae3185"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-2.0.0.gem"
    sha256 "74524686caf43dd56465ba847bd2c33b552028cf23973c4f1fbb5e5971f93a19"
  end

  resource "string_undump" do
    url "https://rubygems.org/gems/string_undump-0.1.1.gem"
    sha256 "7b2b70d86bfac09e774d3be3be1fbae7780ebcd5a1edfdad7bbb15be78ae1793"
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
