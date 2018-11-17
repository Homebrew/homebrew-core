class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/v0.2.1.tar.gz"
  sha256 "85cc53de33a9c2bcf479ad348a73b14017ad082ba41683d9726cb71af1e45ead"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb0d51fd41b424d4c58074112820489959456ac12a09f3ae0abaa929c9c3301c" => :mojave
    sha256 "83cac2d38704559ac200d05fd0cfe8c5c1421aa8535303152c424884c6ba610a" => :high_sierra
    sha256 "0d2b365ef93dabedb031414254a9cfd797aed2fa903bd38120ab6dfbbb7a959b" => :sierra
  end

  depends_on "ruby" if MacOS.version <= :mountain_lion

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "commander" do
    url "https://rubygems.org/gems/commander-4.4.6.gem"
    sha256 "8e73079a5a1efb5c51b604ce427485bd071563ab7e5fb2675f4db40896164d87"
  end

  resource "diffy" do
    url "https://rubygems.org/gems/diffy-3.2.1.gem"
    sha256 "4ffe1a7b01c958053407f9a8e6492c3e8c11b59db0ab5c3ae44f056067ae3185"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-1.7.10.gem"
    sha256 "1e147d5d20f1ad5b0e23357070d1e6d0904ae9f71c3c49e0234cf682ae3c2b06"
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
